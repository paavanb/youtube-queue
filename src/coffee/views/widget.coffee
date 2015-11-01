Ractive = require("ractive")

class QueueWidget extends Ractive
  template: require("../../templates/widget.html")
  data:
    message: "Script tags work!"

module.exports = QueueWidget
