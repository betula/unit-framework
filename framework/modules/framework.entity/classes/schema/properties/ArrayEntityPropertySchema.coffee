# @di
di.provider 'ArrayEntityPropertySchema', (EntityPropertySchemaAbstract) ->

  class ArrayEntityPropertySchema extends EntityPropertySchemaAbstract

    constructor: (options) ->
      super options
      @_type = Array
      @_setDefault ( -> [] ) unless @_hasDefault
