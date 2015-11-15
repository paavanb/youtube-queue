$ = require('jquery')
_ = require('lodash')

config = require('config')
VideoModel = require('coffee/models/video')

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
      return new VideoModel(response.items[0]?.snippet)
    )


module.exports = YoutubeAPI
