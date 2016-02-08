SearchWidget = require('coffee/search/views/widget')


# Bootstrap the video player page to add the search widget
class SearchBootstrapper
  bootstrap: ->
    sidebar_related_videos = $('#watch7-sidebar-modules .watch-sidebar-section')[1]
    if sidebar_related_videos
      new SearchWidget(
        el: sidebar_related_videos
        append: $('.watch-sidebar-body', sidebar_related_videos)
      )


module.exports = SearchBootstrapper