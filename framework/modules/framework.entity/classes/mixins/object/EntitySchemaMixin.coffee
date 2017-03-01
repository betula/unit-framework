# @di
di.provider 'EntitySchemaMixin', (MixinAbstract, EntitySchema, UnitInitMixin, UnitBindMixin, EntityPropertySchemaFactory) ->

  class EntitySchemaMixin extends MixinAbstract

    @dependencies UnitInitMixin, UnitBindMixin

    @schema: (schemas...) ->
      for schema in schemas when schema?
        Object.defineProperty @, '_schema', value: {} unless @hasOwnProperty '_schema'
        if Array.isArray schema
          for key in schema
            @_schema[ key ] = EntityPropertySchemaFactory()
        else
          for own key, value of schema
            @_schema[ key ] = EntityPropertySchemaFactory value

    @_getSchema: ->
      list = []
      context = @
      while context
        list.push context._schema if context._schema?
        context = context.prototype.__proto__?.constructor

      _schema = {}
      for schema in list.reverse()
        for own key, value of schema
          _schema[ key ] = value

      return new EntitySchema _schema

    _getSchema: ->
      unless @__schema?
        @__schema = @constructor._getSchema()
      return @__schema

    _schemaInit: ->
      for name, property of @_getSchema().getProperties() when not @hasOwnProperty name
        @_bind @[ name ] = property.cast()

    _afterSchemaInit: ->

    _preInit: (args...) ->
      EntitySchemaMixin.super @, '_preInit', args...
      @_schemaInit()
      @_afterSchemaInit()


