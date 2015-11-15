Ractive = require("ractive")
Backbone = require('backbone')
BackboneAdaptor = require('ractive-adaptors-backbone')
BackboneAdaptor.Backbone = Backbone

VideoModel = require('coffee/models/video')
VideoItemView = require('coffee/views/video_item')
YoutubeAPI = require('coffee/utils/api')

# View that renders the current list of videos
VideoQueue = Ractive.extend(
  template: require("templates/queue.html")
  isolated: true
  components:
    videoitem: VideoItemView
  adaptors: [BackboneAdaptor]
  data: ->
    videos: []

  onrender: ->
    @init_dropping()

  init_dropping: ->
    @el.addEventListener("dragenter", (e) ->
      e.preventDefault()
    )
    @el.addEventListener("dragover", (e) ->
      e.preventDefault()
    )
    @el.addEventListener("drop", (e) =>
      @add_video(e.dataTransfer.getData("text/uri-list"))
      # prevent default so the browser doesn't follow the link that was dropped
      e.preventDefault()
    )

  add_video: (uri) ->
    url_regex = /watch\?v=([A-Za-z0-9_-]+)$/
    id = uri.match(url_regex)[1]

    YoutubeAPI.get_video(id)
      .then((model) =>
        @get('videos').push(model)
      )
)

module.exports = VideoQueue
