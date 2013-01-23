@WebFITS ?= {}
WebFITS.Routers ?= {}
WebFITS.Views ?= {}
WebFITS.Models ?= {}
WebFITS.Collections ?= {}

$ ->
  # Load App Helpers
  require 'lib/app_helpers'
  
  # Initialize App
  WebFITS.Views.AppView = new AppView = require 'views/app_view'
  
  # Initialize Backbone History
  Backbone.history.start()