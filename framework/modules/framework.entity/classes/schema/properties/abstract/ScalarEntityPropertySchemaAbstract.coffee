# @di
di.provider 'ScalarEntityPropertySchemaAbstract', (EntityPropertySchemaAbstract) ->

  class ScalarEntityPropertySchemaAbstract extends EntityPropertySchemaAbstract

    constructor: (options) ->
      super options
      @_typeOf = @_type.name.toLowerCase() unless @hasOwnProperty '_typeOf'

    _parse: (value) ->
      return @_type value

    _pass: (value) ->
      return true if @_typeOf? and typeof value is @_typeOf
      super value
