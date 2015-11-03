Ractive = require("ractive")

# View that renders the current list of videos
VideoQueue = Ractive.extend(
  template: require("../../templates/queue.html")
  isolated: true
  data:
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
      @get('videos').push(e.dataTransfer.getData("text/uri-list"))
      # prevent default so the browser doesn't follow the link that was dropped
      e.preventDefault()
    )
)

module.exports = VideoQueue
