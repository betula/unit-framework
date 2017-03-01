# @di
di.provider 'EntityValueSchemaMixin', (MixinAbstract, EntityValueMixin, EntitySchemaMixin, EntityPropertySchemaFactory) ->

  class EntityValueSchemaMixin extends MixinAbstract

    @dependencies EntitySchemaMixin, EntityValueMixin

    _schemaInit: ->
      schema = @_getSchema()
      properties = schema.getProperties()
      unless properties[ @_getProp() ]
        properties[ @_getProp() ] = EntityPropertySchemaFactory()
        schema._clearCache()

      EntityValueSchemaMixin.super @, '_schemaInit'


