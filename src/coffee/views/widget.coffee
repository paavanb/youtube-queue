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

    Storage.get('playing')
      .then((items) =>
        playing = items.playing ? false
        @set('playing', playing)
    )

    @on('play-queue', () =>
      @set_playing(true)
        .then(=>
          @go_to_video(@queue.first_video())
          # Set player hooks in case we're already on the page
          @set_player_hooks()
      )
    )

    @on('pause-queue', () =>
      @set_playing(false)
        .then(=>
          @destroy_player_hooks()
      )
    )

    @queue.on('loaded', () =>
      # If we loaded the page and we're in play mode, play the first video. 
      # TODO: We should probably warn that we're redirecting, guaranteed people will forget
      # that the queue is on and get confused by the redirect
      if @get('playing')
        video = @queue.first_video()
        if video
          @go_to_video(video)
          @set_player_hooks()
        else
          # No more videos to play
          @fire('pause-queue')
    )

  # Go to the url of the video represented by the video model
  #   If we're already on the video's page, do nothing.
  #   TODO: What if additional query params are on the video URL? Like time info. Shouldn't redirect.
  go_to_video: (video) ->
    if video and window.location.href != video.get('href')
      window.location.href = video.get('href')

  go_to_next_video: =>
    next_video = @queue.next_video()
    @go_to_video(next_video)

  set_player_hooks: ->
    $('video').on('ended', @go_to_next_video)

  destroy_player_hooks: ->
    video_el = $('video')
    if video_el.length
      video_el.off('ended', @go_to_next_video)

  # Sets the playing value in chrome's local storage as well as on this instance's data
  #  Returns a promise.
  set_playing: (value) ->
    Storage.set('playing', value).then(=>
      @set('playing', value)
    )
)

module.exports = QueueWidget
