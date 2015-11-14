Ractive = require("ractive")

VideoItem = require('coffee/views/video_item')

# View that renders the current list of videos
VideoQueue = Ractive.extend(
  template: require("templates/queue.html")
  isolated: true
  components:
    videoitem: VideoItem
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
    @get('videos').push(uri)
)

module.exports = VideoQueue
