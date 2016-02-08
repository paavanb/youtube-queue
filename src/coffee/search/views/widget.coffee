Ractive = require('ractive')


SearchWidget = Ractive.extend(
  template: require('templates/search/widget.html')
  onrender: ->
    @on('search', ->
      alert('searching')
    )
)


module.exports = SearchWidget
