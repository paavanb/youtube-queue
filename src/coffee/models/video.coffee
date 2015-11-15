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


module.exports = VideoModel
