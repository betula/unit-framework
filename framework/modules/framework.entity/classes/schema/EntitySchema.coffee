# @di
di.provider 'EntitySchema', ->

  class EntitySchema

    constructor: (schema) ->
      @_setSchema schema

    _setSchema: (@_schema = {}) ->
      @_clearCache()

    _clearCache: ->
      @_propertyNames = null

    getPropertyNames: ->
      return (@_propertyNames ?= Object.keys @_schema)

    getProperties: ->
      return @_schema
