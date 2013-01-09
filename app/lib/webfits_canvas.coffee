WebFitsApi = require 'lib/webfits_api'

class WebFitsCanvasApi extends WebFitsApi
  
  constructor: ->
    super
    @scale = {}
    @max = {}
    @alpha = 0.03
    @Q = 1.0
    @sky = {'g': 0, 'r': 0, 'i': 0}
    @colorSat = 1.0
    
    @drawColorDebounce = _.debounce(@drawColor, 150)
    
  getContext: (canvas) ->
    # TODO: Flip Y axis without CSS
    canvas.style.webkitTransform = 'scaleY(-1)'
    @ctx = canvas.getContext('2d')
    return @ctx
  
  # Store a reference to the color bands on the object
  loadTexture: (band, data) =>
    @[band] = data
  
  draw: ->
    console.log 'draw'
  
  setScale: (band, value) ->
    @scale[band] = value
    @drawColorDebounce()
  
  setMax: (band, value) ->
    @max[band] = value
    
  setAlpha: (value) ->
    @alpha = value
    @drawColorDebounce()
  
  setQ: (value) ->
    @Q = value
    @drawColorDebounce()
  
  setBkgdSub: (band, value) ->
    @sky[band] = value
    @draw()
  
  setColorSaturation: (value) ->
    @colorSat = value
    @draw()
  
  drawGrayscale: (band) =>
    
    # Get canvas data
    imgData = @ctx.getImageData(0, 0, @width, @height)
    arr = imgData.data
    min = @arcsinh(@minimum)
    max = @arcsinh(@maximum)
    range = max - min
    
    length = arr.length
    while length -= 4
      value = 255 * (@arcsinh(@[band][length / 4]) - min) / range
      arr[length + 0] = value
      arr[length + 1] = value
      arr[length + 2] = value
      arr[length + 3] = 255
      
    imgData.data = arr
    @ctx.putImageData(imgData, 0, 0)
  
  drawColor: () =>
    console.log 'drawColor'
    # Get canvas data
    imgData = @ctx.getImageData(0, 0, @width, @height)
    arr = imgData.data
    
    length = arr.length
    while length -= 4
      index = length / 4
      r = (@i[index] - @sky['i']) * @scale['i']
      g = (@r[index] - @sky['r']) * @scale['r']
      b = (@g[index] - @sky['g']) * @scale['g']
      
      # Compute the total intensity and stretch factor
      I = r + g + b + 1e-10
      factor = @arcsinh(@alpha * @Q * I) / (@Q * I)
      
      arr[length + 0] = 255 * r * factor
      arr[length + 1] = 255 * g * factor
      arr[length + 2] = 255 * b * factor
      arr[length + 3] = 255
    
    imgData.data = arr
    @ctx.putImageData(imgData, 0, 0)
    
  arcsinh: (value) ->
    return Math.log(value + Math.sqrt(1 + value * value))
    
module.exports = WebFitsCanvasApi