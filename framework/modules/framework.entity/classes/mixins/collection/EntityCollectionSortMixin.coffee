# @di
di.provider 'EntityCollectionSortMixin', (MixinAbstract, EntityCollectionMixin, EntityCollectionDataMixin) ->

  class EntityCollectionSortMixin extends MixinAbstract

    @dependencies EntityCollectionMixin, EntityCollectionDataMixin

    @sort: (key = '@', asc = true) ->

      @_sortConfig ?= {}
      @_sortConfig.key = key
      @_sortConfig.asc = asc

    _getSortStrategy: ->
      if typeof @__sortStrategy is 'undefined'
        config = @constructor._sortConfig
        @__sortStrategy = do (config) =>
          return null unless config?
          return @_sortStrategy.bind @ if config.key is '@'

          return null unless config.key?
          ascSortDirection = if config.asc then -1 else 1

          return ( first, second ) =>
            _first = first?[ config.key ]
            _second = second?[ config.key ]
            return -ascSortDirection if _first > _second
            return ascSortDirection if _first < _second
            return 0

      return @__sortStrategy

    _hasSort: ->
      @_getSortStrategy()?

    _sort: ->
      @sort @_getSortStrategy()

    _sortStrategy: (up, down) ->
      return -1 if up < down
      return 1 if up > down
      return 0

    splice: (args...) ->
      _length = @length
      result = EntityCollectionSortMixin.super @, 'splice', args...
      return result unless @_hasSort()
      [_, deleteCount, values...] = args
      @_sort() if values.length isnt 0 or (deleteCount > 0 and _length isnt 0)
      return result

    push: (args...) ->
      result = EntityCollectionSortMixin.super @, 'push', args...
      return result unless @_hasSort()
      @_sort() if @length isnt 0
      return result

    unshift: (args...) ->
      _length = @length
      result = EntityCollectionSortMixin.super @, 'unshift', args...
      return result unless @_hasSort()
      @_sort() if _length isnt 0
      return result

    assignCollection: (args...) ->
      result = EntityCollectionSortMixin.super @, 'assignCollection', args...
      return result unless @_hasSort()
      @_sort()
      return result

    upsertCollection: (args...) ->
      result = EntityCollectionSortMixin.super @, 'upsertCollection', args...
      return result unless @_hasSort()
      @_sort()
      return result
