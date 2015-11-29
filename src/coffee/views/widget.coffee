Ractive = require("ractive")

VideoQueue = require('coffee/views/queue')
Storage = require('coffee/utils/storage')

# Must use Ractive.extend if we want components to work
QueueWidget = Ractive.extend(
  template: require("templates/widget.html")
  components:
    videoqueue: VideoQueue

  oninit: ->
    Storage.get('playing').then((items) =>
      @set('playing', items.playing ? false)
    )

    @on('play-queue', () ->
      video = @findComponent('videoqueue').pop_video()
      window.location.href = video.get('href')
      Storage.set('playing', true)
    )

    @on('pause-queue', () ->
      Storage.set('playing', false)
    )


)

module.exports = QueueWidget
