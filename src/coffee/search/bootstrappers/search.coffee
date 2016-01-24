SearchWidget = require('coffee/search/views/widget')


# Bootstrap the video player page to add the search widget
class SearchBootstrapper
  bootstrap: ->
    sidebar = $('#watch7-sidebar-contents')
    if sidebar
      new SearchWidget(
        el: sidebar
        append: true
      )


module.exports = SearchBootstrapper
