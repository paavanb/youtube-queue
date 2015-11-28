Ractive = require("ractive")

VideoQueue = require('./queue')

# Must use Ractive.extend if we want components to work
QueueWidget = Ractive.extend(
  template: require("templates/widget.html")
  components:
    videoqueue: VideoQueue

  oninit: ->
    @on('play-queue', () ->
      video = @findComponent('videoqueue').pop_video()
      window.location.href = video.get('href')
    )

)

module.exports = QueueWidget
