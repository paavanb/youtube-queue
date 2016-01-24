QueueWidget = require('./coffee/queue/views/widget')
ThumbnailBootstrapper = require('./coffee/queue/bootstrappers/thumbnail_bootstrapper')
SearchBootstrapper = require('./coffee/search/bootstrappers/search')

var widget = new QueueWidget({
    "el": "body",
    "append": true
})

// Augment the UI with buttons to add videos to queue
new ThumbnailBootstrapper({
    queue_widget: widget
}).bootstrap()

// Augment the UI with a search widget
new SearchWidget().bootstrap()

// Inject google fonts for icons
var link = document.createElement("link");
link.href = "https://fonts.googleapis.com/icon?family=Material+Icons";
link.rel = "stylesheet";
document.getElementsByTagName("head")[0].appendChild(link);
