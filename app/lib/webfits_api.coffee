
class WebFitsApi
  minimum: -2632.8103
  maximum: 17321.828
  width: 401
  height: 401
  
  constructor: ->
    console.log 'WebFitsApi'

  # Setup the DOM with a canvas
  setup: (elem, width, height) ->
    
    # Attach canvas to DOM element
    canvas = document.createElement('canvas')
    canvas.setAttribute('class', 'viewer')
    canvas.setAttribute('width', width)
    canvas.setAttribute('height', height)
    
    elem.appendChild(canvas)
    
    return canvas
  
module.exports = WebFitsApi