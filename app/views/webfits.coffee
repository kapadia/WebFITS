View = require '../lib/view'

ControlView = require 'views/Control'
FitsView    = require 'views/fits'

class WebFitsView extends View
  el: '.container'
  template: require 'views/templates/webfits'
  className: 'webfits'
  
  initialize: ->
    
    @render()
    
    @control  = new ControlView({el: @find('.controls')})
    @fits     = new FitsView({el: @find('.viewer')})
    
    # Bind events
    @fits.on('fits:ready', @onFitsReady)
    @fits.on('fits:scale', @onScaleCompute)
    @fits.on('fits:alpha', @updateAlpha)
    @fits.on('fits:Q', @updateQ)
    
    @control.on('change:band', @onBandChange)
    @control.on('change:extent', @onExtentChange)
    @control.on('change:alpha', @onAlphaChange)
    @control.on('change:Q', @onQChange)
    @control.on('change:scale', @onScaleChange)
    @control.on('change:stretch', @onStretchChange)
  
  render: ->
    @$el.append @template()
  
  onFitsReady: =>
    @control.ready()
    
  onScaleCompute: (band, value) =>
    @control.setComputedScale(band, value)
  
  onBandChange: (band) =>
    @fits.updateBand(band)
  
  onExtentChange: (min, max) =>
    @fits.updateExtent(min, max)
    
  onAlphaChange: (value) =>
    @fits.updateAlpha(value)

  onQChange: (value) =>
    @fits.updateQ(value)
  
  onScaleChange: (band, value) =>
    @fits.updateScale(band, value)
  
  onStretchChange: (value) =>
    @fits.updateStretch(value)
  
  setDataset: (value) =>
    @control.startAjax()
    @fits.requestData(value)
    
  updateAlpha: (value) =>
    @control.updateAlpha(value)
  
  updateQ: (value) =>
    @control.updateQ(value)

module.exports = WebFitsView