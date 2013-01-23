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
    'click input[name="stretch"]'   : 'setStretch'
    'mouseover .help'               : 'showHelp'
    'mouseout .help'                : 'hideHelp'
    
  
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
    # Stop the spinner and enable parameters
    @find('.spinner').removeClass('active')
    @find('*').removeProp('disabled')
    @$el.css('display', 'inline-block')
    
    # Set default states for buttons (these do not fire events)
    @find('label[for="gri"]').click()
    @find('label[for="linear"]').click()
    
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
    
    #
    # Playing with LEAP!
    #
    
    ws = new WebSocket("ws://localhost:6437/")
    ws.onopen = (e) =>
      console.log 'websocket ready'
    ws.onmessage = (e) =>
      lookup = ['gri', 'u', 'g', 'r', 'i', 'z']
      obj = JSON.parse(e.data)
      
      if obj.pointables?
        if obj.pointables.length > 0
          x = obj.pointables[0].tipPosition[0]
          z = obj.pointables[0].tipPosition[2]
          
          return if x < -100
          return if x > 100
          
          # Normalize between 0.01 to 1
          alpha = (0.99 / 200) * (x - 100) + 1
          @trigger('change:alpha', alpha)
          document.querySelector('input[name="alpha"]').value = alpha
  
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

  setStretch: (e) =>
    stretch = @find('input[name="stretch"]:checked + label')[0].dataset.function
    @trigger('change:stretch', stretch)

  showHelp: (e) =>
    info = e.target.parentElement.querySelector('.info')
    info.style.left = e.clientX + 16
    info.style.top = e.clientY
    info.style.display = 'block'
  
  hideHelp: (e) =>
    info = e.target.parentElement.querySelector('.info')
    info.style.display = 'none'
  
  # Methods for keeping UI synchronized with webfits object
  updateAlpha: (value) ->
    @find("input[name='alpha']").val(value)
  
  updateQ: (value) ->
    @find("input[name='Q']").val(value)

module.exports = ControlView