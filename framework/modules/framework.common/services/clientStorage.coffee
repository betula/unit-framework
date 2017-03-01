# @di
di.provider 'clientStorage', (clientStorageLocalStorageDriver, clientStorageCookieDriver) ->

  new class ClientStorage
    constructor: ->
      if clientStorageLocalStorageDriver.available
        @driver = clientStorageLocalStorageDriver
      else
        @driver = clientStorageCookieDriver

    exists: (key) ->
      return (@get key)?

    get: (key) ->
      return @driver.get key

    put: (key, value) ->
      return @driver.put key, value

    remove: (key) ->
      return @driver.remove key


