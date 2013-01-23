
WebFitsView = require 'views/WebFits'
DataSource  = require 'views/DataSource'

class Router extends Backbone.Router
  
  routes:
    '(*state)'  : 'index'
  
  index: (state) ->
    
    # Initialize the WebFITS viewer and DataSource view
    @webfits    = new WebFitsView([state])
    @datasource = new DataSource()
    
    # Bind events
    @datasource.on('change:dataset', @webfits.setDataset)

module.exports = Router