# @di
di.provider 'EntityPropertySchemaAbstract', ->

  class EntityPropertySchemaAbstract

    constructor: (options = {}) ->
      options = type: options if typeof options is 'function'

      @_setEmpty options.empty if options.hasOwnProperty 'empty'
      @_setDefault options.default if options.hasOwnProperty 'default'
      @_type = if typeof options.type is 'function' then options.type else @_type ? Object

    _setDefault: (value) ->
      @_default = value
      @_hasDefault = true

    _setEmpty: (value) ->
      @_empty = value
      @_hasEmpty = true

    _parse: (value) ->
      return unless value? then new @_type else new @_type value

    _pass: (value) ->
      return value instanceof @_type

    _format: (value) ->
      return if value? then value else null

    _checkSpecialCase: (value) ->
      return true if not value and @_hasEmpty
      return true if not value? and @_hasDefault
      return false

    _parseSpecialCase: (value) ->
      if @_hasEmpty and not value
        value = if typeof @_empty is 'function' then @_empty value else @_empty
      if @_hasDefault and not value?
        value = if typeof @_default is 'function' then @_default value else @_default
      return value

    parse: (value) ->
      return @_parseSpecialCase value if @_checkSpecialCase value
      return @_parse value

    cast: (value) ->
      return @_parseSpecialCase value if @_checkSpecialCase value
      return @_parse value unless @_pass value
      return value

    format: (value) ->
      return @_format value

    pass: (value) ->
      return true if @_checkSpecialCase value
      return @_pass value

    getType: ->
      return @_type


