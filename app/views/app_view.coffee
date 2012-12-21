View      = require 'lib/view'
AppRouter = require 'routers/app_router'

WebFitsView = require 'views/webfits'

class AppView extends View
  el: 'body.application'

  initialize: ->
    
    @router = new AppRouter()
    WebFITS?.Routers?.AppRouter = @router
    
    # Initialize the WebFITS viewer
    @webfits = new WebFitsView()


module.exports = AppView