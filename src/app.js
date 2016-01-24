QueueWidget = require('./coffee/queue/views/widget')
ThumbnailBootstrapper = require('./coffee/queue/bootstrappers/thumbnail_bootstrapper')

var widget = new QueueWidget({
    "el": "body",
    "append": true
})

// Augment the UI with buttons to add videos to queue
new ThumbnailBootstrapper({
    queue_widget: widget
}).bootstrap()

// Inject google fonts for icons
var link = document.createElement("link");
link.href = "https://fonts.googleapis.com/icon?family=Material+Icons";
link.rel = "stylesheet";
document.getElementsByTagName("head")[0].appendChild(link);
