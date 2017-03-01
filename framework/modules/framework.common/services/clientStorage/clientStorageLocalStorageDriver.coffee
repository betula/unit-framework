# @di
di.provider 'clientStorageLocalStorageDriver', (window) ->

  new class ClientStorageLocalStorageDriver
    constructor: ->
      try
        @storage = window.localStorage
      @available = @storage?

    isAvailable: ->
      return @available

    get: (key) ->
      if @available
        try
          return JSON.parse @storage.getItem String key

      return null

    put: (key, value) ->
      if @available
        try
          @storage.setItem String(key), JSON.stringify value
          return true

      return false

    remove: (key) ->
      if @available
        try
          @storage.removeItem String key
          return true

      return false
