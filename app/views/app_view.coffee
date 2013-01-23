
AppRouter = require 'routers/app_router'


class AppView extends Backbone.View
  el: 'body.application'

  initialize: ->
    
    @router = new AppRouter()
    WebFITS.Routers.AppRouter = @router


module.exports = AppView