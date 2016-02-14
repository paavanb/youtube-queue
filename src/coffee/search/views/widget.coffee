$ = require('jquery')
Ractive = require('ractive')
Backbone = require('backbone')
BackboneAdaptor = require('ractive-adaptors-backbone')
BackboneAdaptor.Backbone = window.Backbone

YoutubeAPI = require('coffee/utils/api')
VideoModel = require('coffee/queue/models/video')
VideoResultView = require('coffee/search/views/video_result')


SearchWidget = Ractive.extend(
  template: require('templates/search/widget.html')
  components:
    videoresult: VideoResultView
  isolated: true
  adapt: [BackboneAdaptor]
  data:
    videos: new Backbone.Collection([], {model: VideoModel})
  ui:
    results: '#ytq-search-results'

  onrender: ->
    @on('search', @search)

  search: (event) ->
    search_box = event.node[0]
    search_query = search_box.value
    YoutubeAPI.search(search_query)
      .then((videos) =>
        @set('videos', @get('videos').reset())
        @set('videos', videos)

        related_videos = $('#watch7-sidebar-modules .watch-sidebar-section .watch-sidebar-body')[2]
        $(related_videos).hide()
        $(@ui.results).show()
      )

)


module.exports = SearchWidget
