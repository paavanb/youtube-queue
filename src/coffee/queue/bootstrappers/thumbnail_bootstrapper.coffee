$ = require('jquery')
Ractive = require('ractive')

VideoModel = require('coffee/queue/models/video')


# View that renders a simple "add to queue" button for video thumbnails
AddToQueueButton = Ractive.extend(
  template: require('templates/queue/thumbnail_add_to_queue.html')
  append: true

  computed:
    tooltip_text: ->
      if @get('add')
        "Add to Queue"
      else
        "Remove from Queue"

  # TODO: Some sort of reaction when the button is pressed, like the Watch Later button?
  oncomplete: ->
    $(@find('button')).on('click', =>
      if @get('add')
        @fire('add-to-queue', @get('href'))
      else
        @fire('remove-from-queue', @get('href'))

      @set('add', not @get('add'))
    )
)


# Bootstrap video thumbnails with a button to add videos to a queue widget
class ThumbnailBootstrapper
  constructor: (options) ->
    @queue_widget = options.queue_widget

  # Attempt to add an "add to queue" button to all video thumbnails on the page
  bootstrap: ->
    thumbnails = @_get_thumbnails()
    @bootstrap_thumbnail(thumbnail) for thumbnail in thumbnails 

  bootstrap_thumbnail: (thumbnail) =>
    video_link = $("a", thumbnail).attr('href')
    button = new AddToQueueButton(
      el: thumbnail
      data:
        add: not @queue_widget.contains_video(VideoModel.parse_id(video_link))
        href: video_link
    )

    button.on('add-to-queue', (href) =>
      @queue_widget.add_video(href)
    )

    button.on('remove-from-queue', (href) =>
      @queue_widget.remove_video(href)
    )

  _get_thumbnails: ->
    thumbnail_selectors = [
      # These thumbnails exist on videos like on the home page
      ".yt-lockup-thumbnail.contains-addto",
      # These thumbnails exist on the side when playing a video (related videos section)
      ".thumb-wrapper",
      # These thumbnails exist on a channel's landing page
      # TODO Oh man, if people navigate to the "Videos" page of a channel,
      #   It's a SPA, so the page isn't actually refreshed. So the thumbnail button
      #   isn't added. 
      ".yt-lockup-thumbnail .contains-addto"
    ]
    thumbnails = []
    for selector in thumbnail_selectors
      thumbnails = thumbnails.concat($(selector).toArray())

    # The page might update dynamically, so we have to catch new videos that may have appeared
    $('body').on('mouseover', selector, (event) =>
      thumbnail = event.currentTarget
      # Attach the add to queue button if we haven't already
      if not $('.ytq-add-to-queue', thumbnail).length
        @bootstrap_thumbnail(thumbnail)
    ) for selector in thumbnail_selectors

    return thumbnails


module.exports = ThumbnailBootstrapper
