# TODO: Make more appropriate name

View    = require '../lib/view'
Layer   = require '../models/Layer'
Layers  = require '../collections/Layers'


class FitsView extends View
  className: 'viewer'
  
  bands:  ['u', 'g', 'r', 'i', 'z']
  
  width: 401
  height: 401
  surveyMinPixel: -2632.8103
  surveyMaxPixel: 17321.828
  
  # Default parameter values
  defaultAlpha: 0.03
  defaultQ: 1
  
  # Look up table for filter to wavelength conversion (CFHTLS specific)
  # CFHT MegaCam (from http://www.cfht.hawaii.edu/Instruments/Imaging/Megacam/specsinformation.html)
  wavelengths:
    'u.MP9301': 3740
    'g.MP9401': 4870
    'r.MP9601': 6250
    'i.MP9701': 7700
    'i.MP9702': 7700
    'z.MP9801': 9000
  
  initialize: =>
    @getApi()
    
    @on 'webfits:ready', =>
      # NOTE: Dimensions and global extent are hard coded
      @wfits = new astro.WebFITS.Api(@el, @width, @height)
      @wfits.setGlobalExtent(@surveyMinPixel, @surveyMaxPixel)
      ctx = @wfits.getContext()
      
      unless ctx?
        alert 'Something went wrong initializing the context'
      
      @off 'webfits:ready'
    
    # Initialize a collections for storing FITS images
    @collection = new Layers()
  
  getApi: ->
    unless DataView?
      alert 'Sorry, your browser does not support features needed for this tool.'
    
    # Determine if WebGL is supported, otherwise fall back to canvas
    canvas  = document.createElement('canvas')
    context = canvas.getContext('webgl')
    context = canvas.getContext('experimental-webgl') unless context?
    
    # Load appropriate webfits library asynchronously
    lib = if context? then 'gl' else 'canvas'
    url = "javascripts/webfits-#{lib}.js"
    $.getScript(url, => @trigger 'webfits:ready')
    
  requestData: (id) =>
    
    # Clear the collection of previously requested data
    @collection.reset()
    
    dfs = []
    xhrs = []
    for band in @bands
      do (band) =>
        fname = "#{id}_#{band}_sci.fits.fz"
        fpath = "data/#{fname}"
        
        # Initialize deferred object
        d = new $.Deferred()
        dfs.push(d)
        
        xhr = new XMLHttpRequest()
        xhr.open('GET', fpath)
        xhr.responseType = 'arraybuffer'
        xhr.onload = (e) =>
          # Initialize FITS object and read image data
          fits = new astro.FITS.File(xhr.response)
          fits.getDataUnit().getFrame()
          hdu = fits.getHDU()
          
          # Get the scale
          scale = @computeScale(hdu)
          
          # Initialize a model and push to collection
          layer = new Layer({band: band, fits: fits, scale: scale})
          @collection.add(layer)
          
          # Load texture
          @wfits.loadTexture(band, layer.getData())
          
          d.resolve()
        xhrs.push(xhr)
    
    # Now that XHRs are setup, send them off
    xhr.send() for xhr in xhrs
    
    # Setup callback for when all requests are received
    $.when.apply(this, dfs)
      .done( (e) =>
        @computeNormalizedScales()
        
        # Set default parameters
        @trigger 'fits:alpha', @defaultAlpha
        @trigger 'fits:Q', @defaultQ
        
        @wfits.setAlpha(@defaultAlpha)
        @wfits.setQ(@defaultQ)
        @wfits.setupMouseInteraction()
        
        @trigger "fits:ready"
      )
  
  # Convenience function for log base 10
  log10: (x) -> return Math.log(x) / Math.log(10)
  
  # Automatically determine the scale for a given image
  # TODO: Generalize for telescopes other than CFHTLS
  computeScale: (hdu) =>
    
    # Get the zero point and exposure time
    zpoint = hdu.header['PHOT_C']
    exptime = hdu.header['EXPTIME']
    
    # Get the filter and wavelength
    filter = hdu.header['FILTER']
    wavelength = @wavelengths[filter]
    
    return Math.pow(10, zpoint + 2.5 * @log10(wavelength) - 26.0)
  
  # Normalize scales for gri
  computeNormalizedScales: =>
    gri = @collection.getColorLayers()
    
    sum = gri.reduce( (memo, value) ->
      return memo + value.get('scale')
    , 0)
    avg = sum / 3
    
    _.each(gri, (d) =>
      band = d.get('band')
      
      # Compute and set normalized scale
      nscale = d.get('scale') / avg or 1
      d.set('nscale', nscale)
      
      # Send to web fits object
      @trigger 'fits:scale', band, nscale
      @wfits.setScale band, nscale
    )
  
  computeExtent: (data) ->
    min = max = data[0]
    length = data.length
    i = 1
    while i < length
      value = data[i]
      if value < min
        min = value
      else if value > max
        max = value
      i++
    return [min, max]
  
  # Responds to user selection of band
  updateBand: (band) =>
    if band is 'gri'
      fn = 'drawColor'
    else
      fn = 'drawGrayscale'
      
      # Compute the min/max of the image set
      unless @collection.hasExtent
        @collection.each( (l) =>
          [min, max] = @computeExtent(l.getData())
          l.set('minimum', min)
          l.set('maximum', max)
        )
        @collection.hasExtent = true
        mins = @collection.map( (l) -> return l.get('minimum'))
        maxs = @collection.map( (l) -> return l.get('maximum'))
        globalMin = Math.min.apply(Math, mins)
        globalMax = Math.max.apply(Math, maxs)
        @wfits.setGlobalExtent(globalMin, globalMax)
        @wfits.setExtent(0, 1000)
      
      @wfits.setBand(band)
    
    # Call draw function
    @wfits[fn]()
  
  updateExtent: (min, max) =>
    @wfits.setExtent(min, max)
  
  updateAlpha: (value) =>
    @wfits.setAlpha(value)
  
  updateQ: (value) =>
    @wfits.setQ(value)
  
  updateScale: (band, value) =>
    @wfits.setScale(band, value)
  
  updateStretch: (value) =>
    @wfits.setStretch(value)


module.exports = FitsView