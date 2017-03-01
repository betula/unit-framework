# @di
di.provider 'AnyEntityPropertySchema', (EntityPropertySchemaAbstract) ->

  class AnyEntityPropertySchema extends EntityPropertySchemaAbstract

    constructor: (options) ->
      super options
      @_type = null

    _parse: (value) ->
      return value

    _format: (value) ->
      return value

    _pass: ->
      return true


