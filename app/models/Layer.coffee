
# Model representing a single FITS image.  Used to store computed and state parameters
class LayerModel extends Backbone.Model
  
  getData: ->
    return @get('fits').getDataUnit().data
  
module.exports = LayerModel
