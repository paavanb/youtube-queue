$ = require('jquery')
_ = require('lodash')
Backbone = require('backbone')

config = require('config')
VideoModel = require('coffee/queue/models/video')

class YoutubeAPI
  @BASE_URL: "https://www.googleapis.com/youtube/v3"
  @params:
    key: config.YOUTUBE_API_KEY

  @get_video: (video_id) ->
    $.ajax(
      url: "#{@BASE_URL}/videos"
      type: 'GET'
      data: _.extend({}, @params, {
          part: 'snippet'
          id: video_id
        })
    ).then((response) ->
      # TODO If request fails?
      item = response.items[0]
      data =
        id: item?.id
      model_data = _.extend(data, item?.snippet)
      return new VideoModel(model_data)
    )

  @search: (query) ->
    $.ajax(
      url: "#{@BASE_URL}/search"
      type: 'GET'
      data: _.extend({}, @params, {
          q: query
          part: 'snippet'
          type: 'video'
          maxResults: 20
        })
    ).then((response) =>
      # Combine statistics into each video
      items = response.items

      videos = _.map(items, (video) ->
        _.extend({id: video?.id?.videoId}, video.snippet)
      )

      video_ids = _.pluck(videos, 'id').join(',')

      return $.ajax(
        url: "#{@BASE_URL}/videos", 
        data: _.extend({}, @params, 
            part: 'statistics'
            id: video_ids
          )
      ).then((response) ->
        items = response.items

        # Mix statistics into each video
        _.chain(_.zip(videos, items))
          .map((tuple) ->
            _.extend({}, tuple[0], {statistics: tuple[1].statistics})
          )
          .value()
      ).then((video_result_list) ->
        new Backbone.Collection(video_result_list)
      )
    )




module.exports = YoutubeAPI
