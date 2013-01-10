
View    = require '../lib/view'
Layer   = require '../models/Layer'
Layers  = require '../collections/Layers'


class FitsView extends View
  className: 'fits'
  
  bands:  ['u', 'g', 'r', 'i', 'z']
  
  # Percentiles for sky and max levels
  skyp: 0.5
  maxp: 0.995
  
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
    
    # Hide the root element
    @el.style.display = 'none'
    
    @getApi()
    
    @on 'webfits-ready', =>
      # NOTE: Dimensions are hard coded
      @wfits = new astro.WebFITS.Api(@el, 401, 401)
      ctx = @wfits.getContext()
      
      unless ctx?
        alert 'Something went wrong initializing the context'
      
      @off 'webfits-ready'
    
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
    $.getScript(url, => @trigger 'webfits-ready')
    
  requestData: (id) =>
    FITS = astro.FITS
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
          fits = new FITS.File(xhr.response)
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
        @getPercentiles()
        
        # Set default parameters
        @wfits.setAlpha(0.03)
        @wfits.setQ(1)
        
        # Show the root element
        @el.style.display = 'block'
        
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
      nscale = d.get('scale') / avg
      d.set('nscale', nscale)
      
      # Send to web fits object
      @trigger 'fits:scale', band, nscale
      @wfits.setScale band, nscale
    )
  
  # Responds to user selection of band.  Sends image(s) to web fits context.
  getBand: (band) =>
    if band is 'gri'
      @wfits.drawColor()
    else
      @wfits.drawGrayscale(band)
  
  # Compute a percentile by computing rank and selecting on a sorted array
  getPercentile: (sorted, p) ->
    rank = Math.round(p * sorted.length + 0.5)
    return sorted[rank]
  
  # Generic call for various percentiles needed to render image(s)
  getPercentiles: =>
    gri = @collection.getColorLayers()
    
    _.each(gri, (d) =>
      data = d.getData()
      
      # Create a deep copy of the array for sort
      sorted = new Float32Array(data)
      sorted = radixsort()(sorted)
      
      # Get sky and max level
      sky = @getPercentile(sorted, @skyp)
      max = @getPercentile(sorted, @maxp)
      
      # Store on model
      d.set('sky', sky)
      d.set('max', max)
    )
  
  updateExtent: (min, max) =>
    @wfits.setExtent(min, max)
  
  updateAlpha: (value) =>
    @wfits.setAlpha(value)
  
  updateQ: (value) =>
    @wfits.setQ(value)
  
  updateScale: (band, value) =>
    @wfits.setScale(band, value)
  
  updateBkgdSub: (state) =>
    gri = @collection.getColorLayers()
    
    if state
      # Send sky level to GPU
      _.each(gri, (d) =>
        @wfits.setBkgdSub(d.get('band'), d.get('sky'))
      )
    else
      # Send null to GPU
      _.each(gri, (d) =>
        @wfits.setBkgdSub(d.get('band'), 0)
      )
  
  updateColorSaturation: (value) =>
    @wfits.setColorSaturation(value)
  
module.exports = FitsView