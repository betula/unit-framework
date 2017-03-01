# @di
di.provider 'StringEntityPropertySchema', (ScalarEntityPropertySchemaAbstract) ->

  class StringEntityPropertySchema extends ScalarEntityPropertySchemaAbstract

    constructor: (options) ->
      super options
      @_type = String
      @_setDefault '' unless @_hasDefault
