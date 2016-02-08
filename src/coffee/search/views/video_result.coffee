Ractive = require('ractive')
Backbone = require('backbone')
BackboneAdaptor = require('ractive-adaptors-backbone')
BackboneAdaptor.Backbone = window.Backbone

VideoResultView = Ractive.extend(
  template: require('templates/search/video_result.html')
  adapt: [BackboneAdaptor]
)


module.exports = VideoResultView
