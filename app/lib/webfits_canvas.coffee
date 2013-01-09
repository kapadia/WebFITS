WebFitsApi = require 'lib/webfits_api'

class WebFitsCanvasApi extends WebFitsApi
  
  minimum: -2632.8103
  maximum: 17321.828
  width: 401
  height: 401
  
  constructor: ->
    super
    @scale = {}
    @max = {}
    @alpha = 0.03
    @Q = 1.0
    @sky = {'g': 0, 'r': 0, 'i': 0}
    @colorSat = 1.0

  getContext: (canvas) ->
    # TODO: Flip Y axis without CSS
    canvas.style.webkitTransform = 'scaleY(-1)'
    return canvas.getContext('2d')
  
  draw: ->
    console.log 'draw'
  
  setScale: (ctx, band, value) ->
    console.log 'setScale'
    @scale[band] = value
    @draw()
  
  setMax: (ctx, band, value) ->
    console.log 'setMax'
    @max[band] = value
    
  setAlpha: (ctx, value) ->
    console.log 'setAlpha'
    @alpha = value
    @draw()
  
  setQ: (ctx, value) ->
    console.log 'setQ'
    @Q = value
    @draw()
  
  setBkgdSub: (ctx, band, value) ->
    console.log 'setBkgdSub'
    @sky[band] = value
    @draw()
  
  setColorSaturation: (ctx, value) ->
    console.log 'setColorSaturation'
    @colorSat = value
    @draw()
  
  drawGrayScale: (ctx, data, band) =>
    
    # Get canvas data
    imgData = ctx.getImageData(0, 0, @width, @height)
    arr = imgData.data
    min = @arcsinh(@minimum)
    max = @arcsinh(@maximum)
    range = max - min
    
    length = arr.length
    while length -= 4
      value = 255 * (@arcsinh(data[length / 4]) - min) / range
      arr[length + 0] = value
      arr[length + 1] = value
      arr[length + 2] = value
      arr[length + 3] = 255
      
    imgData.data = arr
    ctx.putImageData(imgData, 0, 0)
  
  drawColor: (ctx, data) =>
    # Splat the data for easier reference
    [B, G, R] = data
    
    # Get canvas data
    imgData = ctx.getImageData(0, 0, @width, @height)
    arr = imgData.data
    
    for i in [0..arr.length - 1] by 4
      index = i / 4
      
      r = (R[index] - @sky['i']) * @scale['i']
      g = (G[index] - @sky['r']) * @scale['r']
      b = (B[index] - @sky['g']) * @scale['g']
      
      I = r + g + b + 1e-10
      factor = @arcsinh(@alpha * @Q * I) / (@Q * I)
      
      arr[i + 0] = 255 * r * factor
      arr[i + 1] = 255 * g * factor
      arr[i + 2] = 255 * b * factor
      arr[i + 3] = 255
    
    # for i in [0..100] by 4
    #   console.log i, arr[i]
    
    # length = arr.length
    # while length -= 4
    #   index = length / 4
    #   r = (R[index] - @sky['i']) * @scale['i']
    #   g = (G[index] - @sky['r']) * @scale['r']
    #   b = (B[index] - @sky['g']) * @scale['g']
    #   
    #   # Compute the total intensity and stretch factor
    #   I = r + g + b + 1e-10
    #   factor = @arcsinh(@alpha * @Q * I) / (@Q * I)
    #   
    #   arr[length + 0] = 255 * @clamp(r * factor)
    #   arr[length + 1] = 255 * @clamp(g * factor)
    #   arr[length + 2] = 255 * @clamp(b * factor)
    #   arr[length + 3] = 255
      
    imgData.data = arr
    ctx.putImageData(imgData, 0, 0)
    
  arcsinh: (value) ->
    return Math.log(value + Math.sqrt(1 + value * value))
    
module.exports = WebFitsCanvasApi