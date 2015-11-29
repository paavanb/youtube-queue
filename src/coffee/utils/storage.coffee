_ = require('lodash')

# Utility class for fetching and saving to local storage using Promises
#   (Chrome's storage.local api only supports callbacks)
class Storage
  # Get the data in local storage for a key string or list of key strings
  @get: (keys) ->
    new Promise((resolve, reject) ->
      chrome.storage.local.get(keys, (items) ->
        # lastError is set if there was an error
        if not chrome.runtime.lastError?
          resolve(items)
        else
          reject(chrome.runtime.lastError.message)
      )
    )

  # Set values in storage
  # If an object is passed in, it will be treated as a key-value map of data to store
  # If two arguments are passed in, the first will be treated as string key, and the
  #   the second argument will be treated as the value to set
  @set: () ->
    if arguments.length == 1
      items = arguments[0]
    else
      items = _.set({}, arguments[0], arguments[1])

    new Promise((resolve, reject) ->
      chrome.storage.local.set(items, () ->
        if not chrome.runtime.lastError?
          resolve()
        else
          reject(chrome.runtime.lastError.message)
      )
    )


module.exports = Storage
