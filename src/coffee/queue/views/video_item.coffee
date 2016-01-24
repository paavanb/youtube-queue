Ractive = require("ractive")
Backbone = require('backbone')
BackboneAdaptor = require('ractive-adaptors-backbone')
# The adaptor uses instanceof to check if it should be used, 
#   which breaks if we give it the "copy" of Backbone that 
#   we got using require(). That's why we pass in window.Backbone
BackboneAdaptor.Backbone = window.Backbone

VideoModel = require('coffee/queue/models/video')

VideoItemView = Ractive.extend(
  template: require("templates/video_item.html")
  adapt: [BackboneAdaptor]
  data: ->
    selected: false
)


module.exports = VideoItemView
