View = require '../lib/view'

class FitsView extends View
  className: 'fits'
  
  bands: ['u', 'g', 'r', 'i', 'z']
  
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
    @getApi()
    
    # NOTE: Dimension is currently hard coded
    canvas  = @wfits.setup(@el, 401, 401)
    @ctx    = @wfits.getContext(canvas)
    
    # Checking to make sure context initialize correctly
    unless @ctx?
      alert 'Something went wrong initiaizing a WebGL context'
  
  getApi: ->
    # alert 'Sorry, update your browser' unless DataView?
    # 
    # # Determine if WebGL is supported, otherwise fall back to canvas
    # canvas  = document.createElement('canvas')
    # context = canvas.getContext('webgl')
    # context = canvas.getContext('experimental-webgl') unless context?
    # 
    # checkWebGL = context?
    # 
    # # TODO: Load correct lib asynchronously
    # WebFitsApi = if checkWebGL then require('lib/webfits_webgl') else require('lib/webfits_canvas')
    WebFitsApi = require('lib/webfits_webgl')
    @wfits = new WebFitsApi()

  # NOTE: This is hard coded for a sample data set of CFHTLS 26
  getData: (id) =>
    FITS = astro.FITS
    
    @fits = {}
    dfs = []
    xhrs = []
    for band in @bands
      do (band) =>
        fname = "#{id}_#{band}_sci.fits"
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
          
          # Get the scale and sky level
          @setScale(hdu)
          
          @fits[band] = fits
          d.resolve()
        xhrs.push(xhr)
    
    # Now that XHRs are setup, send them off
    xhr.send() for xhr in xhrs
    
    # Setup call back for when all requests are received
    $.when.apply(this, dfs)
      .done( (e) =>
        @normalizeScales()
        @getPercentiles()
        @trigger "fits:ready"
      )
  
  # Automatically determine the scale for a given image
  # TODO: Generalize for telescopes other than CFHTLS
  setScale: (hdu) =>
    
    # Get the zero point and exposure time
    zpoint = hdu.header['PHOT_C']
    exptime = hdu.header['EXPTIME']
    
    # Get the filter and wavelength
    filter = hdu.header['FILTER']
    wavelength = @wavelengths[filter]
    
    scale = Math.pow(10, zpoint + 2.5 * @log10(wavelength) - 26.0)
    hdu.header['SCALE'] = scale
  
  # Convenience function for log base 10
  log10: (x) -> return Math.log(x) / Math.log(10)
  
  # Normalize scales for gri
  normalizeScales: =>
    scale = 0
    for band in ['g', 'r', 'i']
      scale += @fits[band].getHDU().header['SCALE']
    avg = scale / 3
    
    for band in ['g', 'r', 'i']
      header = @fits[band].getHDU().header
      scale = header['SCALE']
      header['NSCALE'] = scale / avg
      
      @trigger 'fits:scale', band, header['NSCALE']
      @wfits.setScale(@ctx, band, header['NSCALE'])
  
  selectBand: (band) =>
    if band is 'gri'
      arr = []
      for band in band.split('')
        data = @fits[band].getDataUnit().data
        arr.push(data)
      @wfits.drawColor(@ctx, arr)
    else
      data = @fits[band].getDataUnit().data
      @wfits.drawGrayScale(@ctx, data)
  
  getPercentile: (sorted, p) ->
    rank = Math.round(p * sorted.length + 0.5)
    return sorted[rank]
  
  getPercentiles: =>
    
    for band in ['g', 'r', 'i']
      data = @fits[band].getDataUnit().data
      
      # Create a deep copy of the array and sort
      sorted = new Float32Array(data)
      sorted = radixsort()(sorted)
      
      # Get sky level (p = 0.5) and max level (p = 0.9975)
      sky = @getPercentile(sorted, @skyp)
      max = @getPercentile(sorted, @maxp)
      
      @wfits.setSky(@ctx, band, sky)
      @wfits.setMax(@ctx, band, max)
  
  updateAlpha: (value) =>
    @wfits.setAlpha(@ctx, value)
  
  updateQ: (value) =>
    @wfits.setQ(@ctx, value)
    
  updateScale: (band, value) =>
    @wfits.setScale(@ctx, band, value)
  
  updateColorSaturation: (value) =>
    @wfits.setColorSaturation(@ctx, value)
  
module.exports = FitsView