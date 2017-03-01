# @di
di.provider 'locale', (config) ->

  class Locale

    constructor: ->
      @setLocaleId 'en'
      @setDictionary()

    setLocaleId: (@id) ->
      @plural = config.locale.plurals[ @id ]

    setDictionary: (@dictionary = {}) ->

  return new Locale
