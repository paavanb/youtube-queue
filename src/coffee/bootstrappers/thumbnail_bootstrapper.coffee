$ = require('jquery')
Ractive = require('ractive')

# View that renders a simple "add to queue" button for video thumbnails
AddToQueueButton = Ractive.extend(
  template: require('templates/thumbnail_add_to_queue.html')
  append: true
)


# Bootstrap video thumbnails with a button to add videos to a queue widget
class ThumbnailBootstrapper
  constructor: (options) ->
    @queue_widget = options.queue_widget

  # Attempt to add an "add to queue" button to all video thumbnails on the page
  bootstrap: ->
    # Approach 1
    # These thumbnails exist on videos like on the home page
    thumbnails = $(".yt-lockup-thumbnail.contains-addto")
    for thumbnail in thumbnails
      new AddToQueueButton({el: thumbnail})


module.exports = ThumbnailBootstrapper
