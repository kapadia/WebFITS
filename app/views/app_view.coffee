View      = require 'lib/view'
AppRouter = require 'routers/app_router'

WebFitsView = require 'views/WebFits'
DataSource  = require 'views/DataSource'

class AppView extends View
  el: 'body.application'

  initialize: ->
    
    @router = new AppRouter()
    WebFITS?.Routers?.AppRouter = @router
    
    # Initialize the WebFITS viewer
    @webfits = new WebFitsView()
    
    # Initialize DataSource view
    @datasource = new DataSource()
    
    # Bind events
    @datasource.on('change:dataset', @webfits.setDataset)


module.exports = AppView