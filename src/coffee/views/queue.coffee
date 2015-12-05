Ractive = require("ractive")
Backbone = require('backbone')
BackboneAdaptor = require('ractive-adaptors-backbone')
BackboneAdaptor.Backbone = window.Backbone

VideoModel = require('coffee/models/video')
VideoItemView = require('coffee/views/video_item')
YoutubeAPI = require('coffee/utils/api')
Storage = require('coffee/utils/storage')


# View that renders the current list of videos
VideoQueue = Ractive.extend(
  template: require("templates/queue.html")
  isolated: true
  components:
    videoitem: VideoItemView
  adapt: [BackboneAdaptor]

  data: ->
    videos: new Backbone.Collection([], {model: VideoModel})
    playing: false

  oninit: ->
    # First time we load, fetch any videos that were saved before
    Storage.get('videos')
      .then((items) =>
        @load_videos(items.videos ? [])
      )

    # Save videos to local storage when queue is updated
    @get('videos').on('update', ->
      Storage.set(
        videos: @toJSON()
      )
    )

  load_videos: (videos) ->
    @get('videos').add(videos)
    @fire('loaded')

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
      # TODO: What if not a link dropped?
      @add_video(e.dataTransfer.getData("text/uri-list"))
      # prevent default so the browser doesn't follow the link that was dropped
      e.preventDefault()
    )

  add_video: (uri) ->
    # TODO: What if invalid uri? I.e. not a video link or not a link at all
    url_regex = /watch\?v=([A-Za-z0-9_-]+)$/
    id = uri.match(url_regex)[1]

    YoutubeAPI.get_video(id)
      .then((model) =>
        @get('videos').add(model)
      )

  # Get the first video on the queue
  first_video: () ->
    @get('videos').first()

  # Drop the first video on the queue and return the next one
  next_video: ->
    @get('videos').shift()
    @first_video()

)

module.exports = VideoQueue
