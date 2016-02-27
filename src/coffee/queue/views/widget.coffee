$ = require('jquery')
Ractive = require("ractive")

VideoQueue = require('coffee/queue/views/queue')
Storage = require('coffee/utils/storage')

# Must use Ractive.extend if we want components to work
QueueWidget = Ractive.extend(
  ui:
    video: 'video'
    autoplay: '#autoplay-checkbox'
    skip_button: '#skip-btn'

  template: require("templates/queue/widget.html")
  data: ->
    playing: false

  components:
    videoqueue: VideoQueue

  oninit: ->
    @queue = @findComponent('videoqueue')

    Storage.get('playing')
      .then((items) =>
        playing = items.playing ? false
        @set_playing(playing)
    )

    @on('play-queue', () =>
      @set_playing(true)
        .then(=>
          @go_to_video(@queue.first_video())
          # In case we're already on the page
          $(@ui.video)[0].play()
      )
    )

    @on('pause-queue', () =>
      @set_playing(false)
        .then(=>
          @destroy_player_hooks()
          $(@ui.video)[0].pause()
      )
    )

    @on('skip-video', () =>
      @go_to_video(@queue.next_video())
    )

    @queue.on('loaded', () =>
      # If we loaded the page and we're in play mode, play the first video. 
      # TODO: We should probably warn that we're redirecting, guaranteed people will forget
      # that the queue is on and get confused by the redirect
      if @get('playing')
        video = @queue.first_video()
        if video
          @go_to_video(video)
        else
          # No more videos to play
          @fire('pause-queue')
    )

  add_video: (video_uri) ->
    @queue.add_video(video_uri)

  # Go to the url of the video represented by the video model
  #   If we're already on the video's page, do nothing.
  #   TODO: What if additional query params are on the video URL? Like time info. Shouldn't redirect.
  go_to_video: (video) ->
    if video
      if window.location.href != video.get('href')
        window.location.href = video.get('href')
      else
        @set_player_hooks()
    else
      @fire('pause-queue')

  go_to_next_video: ->
    next_video = @queue.next_video()
    @go_to_video(next_video)

  set_player_hooks: ->
    @disable_autoplay()
    $(@ui.video).on('ended', @go_to_next_video.bind(this))

  destroy_player_hooks: ->
    video_el = $('video')
    if video_el.length
      video_el.off('ended', @go_to_next_video.bind(this))

  # Disable youtube autoplay. Autoplaying masks the video ended event, making it impossible
  #   to go to the next video
  disable_autoplay: ->
    checkbox = $(@ui.autoplay)
    if checkbox.prop('checked')
      # TODO Gross hack, perhaps show a popover to be like "yo we're switching this off for you"
      setTimeout(->
        checkbox.click()
      , 5000)


  # Sets the playing value in chrome's local storage as well as on this instance's data
  #  Returns a promise.
  set_playing: (value) ->
    Storage.set('playing', value).then(=>
      @set('playing', value)
      return value
    )
  )

module.exports = QueueWidget
