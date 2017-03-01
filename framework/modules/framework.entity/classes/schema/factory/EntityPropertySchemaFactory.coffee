# @di
di.provider 'EntityPropertySchemaFactory', (
  injector
  AnyEntityPropertySchema,
  GenericEntityPropertySchema
  EntityPropertySchemaAbstract
  ArrayEntityPropertySchema
  BooleanEntityPropertySchema
  DateEntityPropertySchema
  NumberEntityPropertySchema
  StringEntityPropertySchema
  lodash) ->

  (data) ->
    if arguments.length is 0
      new AnyEntityPropertySchema

    else if typeof data is 'function'
      switch data
        when Boolean then new BooleanEntityPropertySchema data
        when Number then new NumberEntityPropertySchema data
        when String then new StringEntityPropertySchema data
        when Array then new ArrayEntityPropertySchema data
        when Date then new DateEntityPropertySchema data
        else new GenericEntityPropertySchema data

    else if data instanceof EntityPropertySchemaAbstract
      data

    else if typeof data is 'string'
      new (injector.get data + 'EntityPropertySchema')

    else
      if typeof data?.type is 'function'
        switch data.type
          when Boolean then new BooleanEntityPropertySchema data
          when Number then new NumberEntityPropertySchema data
          when String then new StringEntityPropertySchema data
          when Array then new ArrayEntityPropertySchema data
          when Date then new DateEntityPropertySchema data
          else new GenericEntityPropertySchema data

      else if typeof data.type is 'string'
        new (injector.get data.type + 'EntityPropertySchema') lodash.omit data, 'type'

      else
        new AnyEntityPropertySchema data

