WebFitsApi = require 'lib/webfits_api'

class WebFitsCanvasApi extends WebFitsApi
  
  constructor: ->
    console.log 'WebFitsApi for Canvas'
    
  getContext: (canvas) ->
    return canvas.getContext('2d')
  
module.exports = WebFitsCanvasApi