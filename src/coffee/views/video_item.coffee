Ractive = require("ractive")

VideoItem = Ractive.extend(
  template: require("templates/video_item.html")
  computed:
    video_id: ->
      # TODO What happens when match fails?
      url_regex = /watch\?v=([A-Za-z0-9_-]+)$/
      @get('url').match(url_regex)[1]
)


module.exports = VideoItem
