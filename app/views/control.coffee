View = require '../lib/view'

class ControlView extends View
  template: require 'views/templates/control'
  className: 'control'
  
  events:
    'click  input[name="band"]'     : 'setBand'
    'change input[name="alpha"]'    : 'setAlpha'
    'change input[name="Q"]'        : 'setQ'
    'change input.scale'            : 'setScale'
    'change input.extent'           : 'setExtent'
  
  initialize: =>
    @render()
    
    # Load shim if on Firefox
    if $.browser.mozilla
      $.getScript('javascripts/html5slider.js')
    
    # Disable all DIVs
    @find('*').prop('disabled', 'disabled')
    
    # Cache DOM elements
    @alpha  = @find('input[name="alpha"] + .parameter')
    @Q      = @find('input[name="Q"] + .parameter')
    @g      = @find('input[name="g"] + .parameter')
    @r      = @find('input[name="r"] + .parameter')
    @i      = @find('input[name="i"] + .parameter')
    @params = @find('.parameters')
  
  render: ->
    @$el.append @template()
  
  startAjax: ->
    @find('.spinner').addClass('active')
  
  # Ready is called when all FITS images have been transferred.
  ready: ->
    @find('.spinner').removeClass('active')
    @find('*').removeProp('disabled')
    @find('label[for="gri"]').click()
    @find('.parameters').show()
    @setBand()
  
  setComputedScale: (band, value) ->
    @find("input[name='#{band}']").val(value)
  
  setBand: ->
    band = @find('input[name="band"]:checked + label')[0].dataset.band
    if band is 'gri'
      # Hide grayscale tools and show color tools
      @params.filter('.color').show()
      @params.filter('.grayscale').hide()
    else
      # Hide color tools and show grayscale tools
      @params.filter('.color').hide()
      @params.filter('.grayscale').show()
    @trigger('change:band', band)
  
  setExtent: (e) ->
    min = @find('input[name="min"]').val()
    max = @find('input[name="max"]').val()
    
    @trigger('change:extent', min, max)
  
  setAlpha: (e) ->
    val = e.target.value
    @alpha.text("α: #{val}")
    @alpha.offset({top: e.target.offsetTop - 10, left: 401 * val / 1})
    
    @trigger('change:alpha', val)
  
  setQ: (e) ->
    val = e.target.value
    @Q.text("Q: #{val}")
    @Q.offset({top: e.target.offsetTop - 10, left: 401 * val / 100})
    
    @trigger('change:Q', val)
  
  setScale: (e) =>
    val = e.target.value
    band = e.target.name
    @[band].text("#{band}: #{val}")
    @[band].offset({top: e.target.offsetTop - 10, left: 401 * val / 2})
    
    @trigger('change:scale', band, val)

  # Methods for keeping UI synchronized with webfits object
  updateAlpha: (value) ->
    @find("input[name='alpha']").val(value)
  
  updateQ: (value) ->
    @find("input[name='Q']").val(value)

module.exports = ControlView