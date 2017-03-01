# @di
di.provider 'DateEntityPropertySchema', (EntityPropertySchemaAbstract) ->

  class DateEntityPropertySchema extends EntityPropertySchemaAbstract

    constructor: (options) ->
      super options
      @_type = Date
      @_setDefault ( -> new Date undefined ) unless @_hasDefault
