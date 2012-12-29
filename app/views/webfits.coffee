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
    @fits.on('fits:scale', @onScaleCompute)
    @control.on('change:band', @onBandChange)
    @control.on('change:alpha', @onAlphaChange)
    @control.on('change:Q', @onQChange)
    @control.on('change:scale', @onScaleChange)
    @control.on('change:colorsat', @onSaturationChange)
  
  render: ->
    @$el.append @template()
  
  onFitsReady: =>
    @control.ready()
    
  onScaleCompute: (band, value) =>
    @control.setComputedScale(band, value)
  
  onBandChange: (band) =>
    @fits.selectBand(band)

  onAlphaChange: (value) =>
    @fits.updateAlpha(value)

  onQChange: (value) =>
    @fits.updateQ(value)
  
  onScaleChange: (band, value) =>
    @fits.updateScale(band, value)
  
  onSaturationChange: (value) =>
    @fits.updateColorSaturation(value)
  
  setDataset: (value) =>
    @control.startAjax()
    @fits.getData(value)

module.exports = WebFitsView