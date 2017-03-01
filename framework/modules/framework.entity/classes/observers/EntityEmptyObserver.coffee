# @di
di.provider 'EntityEmptyObserver', (EntityChangeBasedObserverAbstract) ->

  class EntityEmptyObserver extends EntityChangeBasedObserverAbstract

    _setEntity: (args...) ->
      super args...
      @_empty = @_isEntityDataEmpty()

    _isEntityDataEmpty: ->
      return @_unit.isDataEmpty()

    _check: ->
      if @_isEntityDataEmpty()
        @_setEmpty()
      else
        @_setNotEmpty()

    _setNotEmpty: ->
      if @_empty
        @_empty = false
        @emit 'filled'

    _setEmpty: ->
      unless @_empty
        @_empty = true
        @emit 'empty'

    isEmpty: ->
      return @_empty

    isNotEmpty: ->
      return not @_empty
