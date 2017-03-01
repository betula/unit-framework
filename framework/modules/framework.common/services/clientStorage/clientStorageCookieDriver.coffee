# @di
di.provider 'clientStorageCookieDriver', (window, cookies) ->

  new class ClientStorageCookieDriver
    constructor: ->
      @storage = cookies
      @available = window.navigator.cookieEnabled

    isAvailable: ->
      return @available

    get: (key) ->
      if @available
        try
          return @storage.getJSON String key

      return null

    put: (key, value) ->
      if @available
        try
          @storage.set String( key ), value
          return true

      return false

    remove: (key) ->
      if @available
        try
          @storage.remove String key
          return true

      return false
