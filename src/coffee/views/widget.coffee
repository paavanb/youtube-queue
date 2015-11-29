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

    @on('play-queue', () ->
      video = @queue.first_video()
      window.location.href = video.get('href')
      Storage.set('playing', true).then(=>
        @set('playing', true)
      )
    )

    @on('pause-queue', () ->
      Storage.set('playing', false).then(=>
        @set('playing', false)
      )
    )

    @queue.on('loaded', () =>
      if @get('playing') and window.location.href == @queue.first_video()?.get('href')
        @set_player_hooks()
    )

  set_player_hooks: ->
    debugger
)

module.exports = QueueWidget
