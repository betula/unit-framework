# @di
di.provider 'UnitCollectionObserver', (UnitApplyBasedObserverAbstract) ->

  class UnitCollectionObserver extends UnitApplyBasedObserverAbstract

    _setUnit: (args...) ->
      super args...
      @_storeUnitCollection()

    _storeUnitCollection: ->
      @_storedUnitCollection = Array::slice.call @_unit

    _isUnitCollectionChanged: ->
      collection = @_storedUnitCollection or []
      return true if collection.length isnt @_unit.length
      for value, index in collection when value isnt @_unit[ index ]
        return true

    _check: ->
      if @_isUnitCollectionChanged()
        _previous = @_storedUnitCollection
        @_storeUnitCollection()
        @emit 'collection', @_storedUnitCollection, _previous
