# @di
di.provider 'EntityCollectionMapMixin', (MixinAbstract, EntityCollectionMixin, UnitBindMixin) ->

  class EntityCollectionMapMixin extends MixinAbstract

    @dependencies EntityCollectionMixin, UnitBindMixin

    @map: (@_mapKey) ->

    _getMapKey: ->
      return @constructor._mapKey

    _hasMap: ->
      return @_getMapKey()?

    _addToMap: (entity) ->
      if entity?
        key = @_getMapKey()
        index = if key is '@' then @_mapStrategy entity else entity[ key ]
        @[ index ] = entity

    _removeFromMap: (entity) ->
      if entity?
        key = @_getMapKey()
        index = if key is '@' then @_mapStrategy entity else entity[ key ]
        delete @[ index ]

    _bindCollectionElement: (entity) ->
      EntityCollectionMapMixin.super @, '_bindCollectionElement', entity
      @_addToMap entity if @_hasMap() and entity?

    _unBindCollectionElement: (entity) ->
      EntityCollectionMapMixin.super @, '_unBindCollectionElement', entity
      @_removeFromMap entity if @_hasMap() and entity?

    _mapStrategy: (value) -> String value
