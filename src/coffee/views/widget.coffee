Ractive = require("ractive")

VideoQueue = require('./queue')

# Must use Ractive.extend if we want components to work
QueueWidget = Ractive.extend(
  template: require("templates/widget.html")
  components:
    videoqueue: VideoQueue
)

module.exports = QueueWidget
