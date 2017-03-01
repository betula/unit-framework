# @di
di.provider 'EntityCollectionSchemaMixin', (MixinAbstract, EntityPropertySchemaFactory, EntityCollectionMixin) ->

  class EntityCollectionSchemaMixin extends MixinAbstract

    @dependencies EntityCollectionMixin

    @of: (@_collectionSchema) ->

    _getCollectionSchema: ->
      unless @__collectionSchema?
        schema = @constructor._collectionSchema
        @__collectionSchema = (schema and EntityPropertySchemaFactory schema) or EntityPropertySchemaFactory()
      return @__collectionSchema


    splice: (start, deleteCount, values...) ->
      schema = @_getCollectionSchema()
      for value, index in values
        values[ index ] = schema.cast value
      return EntityCollectionSchemaMixin.super @, 'splice', start, deleteCount, values...

    push: (values...) ->
      schema = @_getCollectionSchema()
      for value, index in values
        values[ index ] = schema.cast value
      return EntityCollectionSchemaMixin.super @, 'push', values...

    unshift: (values...) ->
      schema = @_getCollectionSchema()
      for value, index in values
        values[ index ] = schema.cast value
      return EntityCollectionSchemaMixin.super @, 'unshift', values...
