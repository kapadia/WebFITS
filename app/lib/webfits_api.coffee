
class WebFitsApi
  scales: {}
  
  constructor: ->
    console.log 'WebFitsApi for WebGL'

  # Setup the DOM for the WebGL context
  setup: (elem, width, height) ->
    console.log 'setup'
    
    # Attach canvas to DOM element
    canvas = document.createElement('canvas')
    canvas.setAttribute('class', 'viewer')
    canvas.setAttribute('width', width)
    canvas.setAttribute('height', height)
    
    elem.appendChild(canvas)
    
    return canvas
  
  addFrame: (fits) =>
    console.log 'addFrame'
  
  setScale: (ctx, band, scale) =>
    @scales[band] = scale
  
  draw: =>
    console.log 'draw'
  
module.exports = WebFitsApi