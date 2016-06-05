SearchWidget = require('coffee/search/views/widget')

# Bootstrap the video player page to add the search widget
class SearchBootstrapper
  bootstrap: ->
    @append_widget()

    # Watch for changes to sidebar, page may have updated in place. Add widget again
    target = document.getElementById('content')
    observer = new MutationObserver(@append_widget.bind(this))
    observer.observe(target,
      childList: true
    )

  append_widget: ->
    sidebar_container = $('#watch7-container')[0]

    # We're on a page with a video playing
    if sidebar_container
      sidebar_related_videos = $('#watch7-sidebar-modules .watch-sidebar-section')[1]
      # If the sidebar has been populated
      if sidebar_related_videos
        search_box = $('#searchbox-container')[0]
        # If the search box hasn't been added by us yet
        if not search_box?
          new SearchWidget(
            el: sidebar_related_videos
            append: $('.watch-sidebar-body', sidebar_related_videos)
          )
      else
        # Sidebar has not been populated yet, wait for more rendering to try again
        window.requestAnimationFrame(@append_widget.bind(this))


module.exports = SearchBootstrapper
