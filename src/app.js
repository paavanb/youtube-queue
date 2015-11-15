QueueWidget = require('./coffee/views/widget')

var widget = new QueueWidget({
    "el": "body",
    "append": true
})

// Inject google fonts for icons
var link = document.createElement("link");
link.href = "https://fonts.googleapis.com/icon?family=Material+Icons";
link.rel = "stylesheet";
document.getElementsByTagName("head")[0].appendChild(link);
