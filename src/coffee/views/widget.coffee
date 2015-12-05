$ = require('jquery')
Ractive = require("ractive")

VideoQueue = require('coffee/views/queue')
Storage = require('coffee/utils/storage')

# Must use Ractive.extend if we want components to work
QueueWidget = Ractive.extend(
  template: require("templates/widget.html")
  data: ->
    playing: false

  components:
    videoqueue: VideoQueue

  oninit: ->
    @queue = @findComponent('videoqueue')

    Storage.get('playing').then((items) =>
      @set('playing', items.playing ? false)
    )

    @on('play-queue', () =>
      video = @queue.first_video()
      @go_to_video(video)
      Storage.set('playing', true).then(=>
        @set('playing', true)
      )
    )

    @on('pause-queue', () =>
      Storage.set('playing', false).then(=>
        @set('playing', false)
      )
    )

    @queue.on('loaded', () =>
      if @get('playing')
        @go_to_video(@queue.first_video())
        @set_player_hooks()
    )

  # Go to the url of the video represented by the video model
  #   If we're already on the video's page, do nothing.
  #   TODO: What if additional query params are on the video URL? Like time info. Shouldn't redirect.
  go_to_video: (video) ->
    if video and window.location.href != video.get('href')
      window.location.href = video.get('href')

  set_player_hooks: ->
    $('video').on('ended', () => 
      next_video = @queue.next_video()
      if next_video
        @go_to_video(next_video)
    )
)

module.exports = QueueWidget
