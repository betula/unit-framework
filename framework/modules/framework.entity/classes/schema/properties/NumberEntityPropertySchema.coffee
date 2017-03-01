# @di
di.provider 'NumberEntityPropertySchema', (ScalarEntityPropertySchemaAbstract) ->

  class NumberEntityPropertySchema extends ScalarEntityPropertySchemaAbstract

    constructor: (options) ->
      super options
      @_type = Number
      @_setDefault 0 unless @_hasDefault
