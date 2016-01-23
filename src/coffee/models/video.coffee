Backbone = require('backbone')

class VideoModel extends Backbone.Model
  defaults:
    title: ''
    thumbnails: 
      default:
        url: ''
      medium:
        url: ''
      high:
        url: ''
      standard:
        url: ''
      maxres:
        url: ''

  initialize: ->
    # TODO Link href to change:id event?
    @set('href', "https://www.youtube.com/watch?v=#{@get('id')}")


module.exports = VideoModel
