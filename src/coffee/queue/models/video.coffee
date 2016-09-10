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

  ###
  Parse the video id out of a uri of the form "/watch?v=ID"
  ###
  @parse_id: (uri) ->
    url_regex = /watch\?v=([A-Za-z0-9_-]+)$/
    id = uri.match(url_regex)[1]
    return id


module.exports = VideoModel
