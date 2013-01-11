View = require '../lib/view'

class DataSourceView extends View
  el: '.container'
  template: require 'views/templates/datasource'
  className: 'DataSource'
  
  events:
    'click li.dataset'  : 'selectDataset'
  
  initialize: ->
    @render()
    
  render: ->
    prefixes = []
    for i in [1..30]
      num = String('0' + i).slice(-2)
      prefixes.push "CFHTLS_#{num}"
    
    @$el.append @template({source: prefixes})

  selectDataset: (e) ->
    @trigger 'change:dataset', e.target.textContent
  
module.exports = DataSourceView