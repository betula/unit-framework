# @di
di.provider 'EntityCollectionIndexMixin', (MixinAbstract, EntityCollectionMixin, UnitBindMixin, EntityMixin) ->

  class EntityCollectionIndexMixin extends MixinAbstract

    @dependencies EntityCollectionMixin, UnitBindMixin

    @index: (key = '@') ->
      @_indexKey = key

    _getIndexKey: ->
      return @constructor._indexKey

    _getIndex: ->
      @__index ?= {} if @_getIndexKey()?

    _hasIndex: ->
      return @_getIndexKey()?

    _bindCollectionElement: (entity) ->
      EntityCollectionIndexMixin.super @, '_bindCollectionElement', entity
      @_addToIndex (@_extractIndex entity), entity if @_hasIndex()

    _unBindCollectionElement: (entity) ->
      EntityCollectionIndexMixin.super @, '_unBindCollectionElement', entity
      @_removeFromIndex @_extractIndex entity if @_hasIndex()

    _extractIndex: (value) ->
      key = @_getIndexKey()
      return @_indexStrategy value if key is '@'
      return String value?[ key ]

    _addToIndex: (key, entity) ->
      @_getIndex()[ key ] = entity

    _removeFromIndex: (key) ->
      delete @_getIndex()[ key ]

    _findByIndex: (key) ->
      @_getIndex()[ key ]

    find: (value) ->
      return @_findByIndex @_extractIndex value if @_hasIndex()
      position = @indexOf( value )
      return @[ position ] if position isnt -1

    findByIndex: (key) ->
      return @_findByIndex key if @_hasIndex()

    exists: (value) ->
      return (@find value)?

    existsByIndex: (key) ->
      return (@findByIndex key)?

    _indexStrategy: (value) -> String value
