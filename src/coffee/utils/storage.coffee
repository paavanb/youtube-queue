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

  # items is a key-value map of data to store
  @set: (items) ->
    new Promise((resolve, reject) ->
      chrome.storage.local.set(items, () ->
        if not chrome.runtime.lastError?
          resolve()
        else
          reject(chrome.runtime.lastError.message)
      )
    )


module.exports = Storage
