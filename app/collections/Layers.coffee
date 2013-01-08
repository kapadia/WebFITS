
# Collection of layers where each layer corresponds to a FITS image
class LayersCollection extends Backbone.Collection
  model: require 'models/Layer'
  
  getColorLayers: ->
    layers = []
    layers.push @where({band: 'g'})[0]
    layers.push @where({band: 'r'})[0]
    layers.push @where({band: 'i'})[0]
    return layers

module.exports = LayersCollection