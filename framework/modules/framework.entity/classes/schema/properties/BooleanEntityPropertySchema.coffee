# @di
di.provider 'BooleanEntityPropertySchema', (ScalarEntityPropertySchemaAbstract) ->

  class BooleanEntityPropertySchema extends ScalarEntityPropertySchemaAbstract

    constructor: (options) ->
      super options
      @_type = Boolean
