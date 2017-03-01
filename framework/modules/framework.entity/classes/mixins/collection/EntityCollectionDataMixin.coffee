# @di
di.provider 'EntityCollectionDataMixin', (MixinAbstract, EntityDataMixin, EntityCollectionSchemaMixin, EntityCollectionMixin, EntityCollectionIndexMixin, EntityCollectionUpsertMixin) ->

  class EntityCollectionDataMixin extends MixinAbstract

    @dependencies EntityCollectionSchemaMixin, EntityDataMixin, EntityCollectionMixin, EntityCollectionIndexMixin, EntityCollectionUpsertMixin

    _setData: (data) ->
      if arguments.length is 0
        EntityCollectionDataMixin.super @, '_setData'
        return

      EntityCollectionDataMixin.super @, '_setData', data

      if data instanceof Array
        @assignCollection(data)

    assignCollection: (data) ->

      if @length is 0
        @push data...
        return

      unless @_hasIndex()
        @reset data
        return

      schema = @_getCollectionSchema()
      elementType = schema.getType()
      if not elementType? or not EntityDataMixin.hasInClass elementType
        @reset data
        return

      @_applyLock()

      result = []
      result.length = data.length

      positionTable = {}
      itemTable = {}
      for item, position in data
        key = @_extractIndex item


        positionTable[ key ] = position
        itemTable[ key ] = item

      usedPositions = {}
      removed = []

      for item in @
        key = @_extractIndex item

        position = positionTable[ key ]

        unless position?
          removed.push item
          continue

        item.setData itemTable[ key ]
        result[ position ] = item

        usedPositions[ position ] = true

      for item in removed
        @_unBindCollectionElement item

      for index in [ 0 ... data.length ] when not usedPositions.hasOwnProperty index
        item = schema.cast data[ index ]
        result[ index ] = item
        @_bindCollectionElement item

      for item, index in result
        @[ index ] = item

      @length = result.length

      @_applyUnLock()
      @apply()

    upsertCollection: (data) ->

      if @length is 0
        @push data...
        return

      schema = @_getCollectionSchema()
      elementType = schema.getType()
      if not elementType? or not EntityDataMixin.hasInClass elementType
        @reset data
        return

      @_applyLock()

      for item in data
        @upsert item

      @_applyUnLock()
      @apply()


    _getData: ->
      result = @slice()

      schema = @_getCollectionSchema()
      for value, index in result
        if value? and EntityDataMixin.hasIn value
          result[ index ] = value.getData()
        else
          result[ index ] = schema.format value

      data = EntityCollectionDataMixin.super @, '_getData'
      for own key, value of data
        result[ key ] = value

      return result
