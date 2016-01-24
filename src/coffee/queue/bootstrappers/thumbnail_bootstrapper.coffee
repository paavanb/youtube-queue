$ = require('jquery')
Ractive = require('ractive')

# View that renders a simple "add to queue" button for video thumbnails
AddToQueueButton = Ractive.extend(
  template: require('templates/queue/thumbnail_add_to_queue.html')
  append: true

  # TODO: Some sort of reaction when the button is pressed, like the Watch Later button?
  oncomplete: ->
    $(@find('button')).on('click', =>
      @fire('add-to-queue', @get('href'))
    )
)


# Bootstrap video thumbnails with a button to add videos to a queue widget
class ThumbnailBootstrapper
  constructor: (options) ->
    @queue_widget = options.queue_widget

  # Attempt to add an "add to queue" button to all video thumbnails on the page
  bootstrap: ->
    thumbnails = @_get_thumbnails()
    for thumbnail in thumbnails
      video_link = $("a", thumbnail).attr('href')
      button = new AddToQueueButton(
        el: thumbnail
        data:
          href: video_link
      )

      button.on('add-to-queue', (href) =>
        @queue_widget.add_video(href)
      )

  _get_thumbnails: ->
    # Approach 1
    # These thumbnails exist on videos like on the home page
    thumbnails = $(".yt-lockup-thumbnail.contains-addto").toArray()

    # Approach 2
    # These thumbnails exist on the side when playing a video (related videos section)
    thumbnails = thumbnails.concat($(".thumb-wrapper").toArray())

    # Approach 3
    # These thumbnails exist on a channel's landing page
    # TODO Oh man, if people navigate to the "Videos" page of a channel,
    #   It's a SPA, so the page isn't actually refreshed. So the thumbnail button
    #   isn't added. 
    thumbnails = thumbnails.concat($(".yt-lockup-thumbnail .contains-addto").toArray())

    return thumbnails


module.exports = ThumbnailBootstrapper
