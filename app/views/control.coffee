View = require '../lib/view'

class ControlView extends View
  template: require 'views/templates/control'
  className: 'control'
  
  events:
    'click  input[name="band"]'     : 'setBand'
    'change input[name="alpha"]'    : 'setAlpha'
    'change input[name="Q"]'        : 'setQ'
    'change input.scale'            : 'setScale'
    'change input[name="colorsat"]' : 'setColorSaturation'
    'change input[name="bkgdsub"]'  : 'setBkgdSub'
  
  initialize: =>
    @render()
    
    # Disable all DIVs
    @find('*').prop('disabled', 'disabled')
    
    # Cache DOM elements
    @ranges = @find('input[type="range"]')
    @alpha  = @find('input[name="alpha"] + .parameter')
    @Q      = @find('input[name="Q"] + .parameter')
    @g      = @find('input[name="g"] + .parameter')
    @r      = @find('input[name="r"] + .parameter')
    @i      = @find('input[name="i"] + .parameter')
    @bkgd   = @find('input[name="bkgdsub"]')
    @sat    = @find('input[name="colorsat"] + .parameter')
  
  render: ->
    @$el.append @template()
  
  startAjax: ->
    @find('.spinner').addClass('active')
  
  # Ready is called when all FITS images have been transferred.
  ready: ->
    @find('.spinner').removeClass('active')
    @find('*').removeProp('disabled')
    @find('label[for="r"]').click()
    @setBand()
  
  setComputedScale: (band, value) ->
    @find("input[name='#{band}']").val(value)
  
  setBand: ->
    band = @find('input[name="band"]:checked + label')[0].dataset.band
    if band is 'gri'
      @ranges.removeAttr('disabled')
    else
      @ranges.attr('disabled', 'disabled')
    
    @trigger('change:band', band)
  
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
  
  setBkgdSub: (e) =>
    state = @bkgd.is(':checked')
    
    @trigger('change:bkgdsub', state)
  
  setColorSaturation: (e) =>
    val = e.target.value
    @sat.text("Sat: #{val}")
    @sat.offset({top: e.target.offsetTop - 10, left: 401 * val / 5})
    
    @trigger('change:colorsat', val)
    
module.exports = ControlView