# @di
di.provider 'EntityCollectionUpsertMixin', (MixinAbstract, EntityCollectionIndexMixin, EntityDataMixin, EntityCollectionSchemaMixin) ->

  class EntityCollectionUpsertMixin extends MixinAbstract

    @dependencies EntityCollectionIndexMixin, EntityCollectionSchemaMixin

    upsert: (entity) ->
      if @exists entity
        @update entity
      else
        entity = (@push entity)[ 0 ]
        return entity

    update: (key, data) ->
      data = key if arguments.length is 1
      entity = @find key
      if EntityDataMixin.hasIn entity
        entity.setData data
      else
        position = @indexOf entity
        @[ position ] = @_getCollectionSchema().cast data
        @_unBindCollectionElement entity
        @_bindCollectionElement @[ position ]

      return entity
