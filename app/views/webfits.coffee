View = require '../lib/view'

ControlView = require 'views/Control'
FitsView    = require 'views/fits'

class WebFitsView extends View
  el: 'body.application'
  template: require 'views/templates/webfits'
  className: 'webfits'
  
  initialize: ->
    
    @render()
    
    @control  = new ControlView({el: @find('.controls')})
    @fits     = new FitsView({el: @find('.fits')})
    
    # Bind events
    @fits.on('fits:ready', @onFitsReady)
    @control.on('change:band', @onBandChange)
    @control.on('change:alpha', @onAlphaChange)
    @control.on('change:Q', @onQChange)
  
  render: ->
    @$el.append @template()
  
  onFitsReady: =>
    @control.ready()
  
  onBandChange: (band) =>
    @fits.selectBand(band)

  onAlphaChange: (value) =>
    @fits.updateAlpha(value)

  onQChange: (value) =>
    @fits.updateQ(value)
  
  setDataset: (value) =>
    @control.startAjax()
    @fits.getData(value)

module.exports = WebFitsView