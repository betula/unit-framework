# @di
di.provider 'EntityStructureObserver', (EntityApplyBasedObserverAbstract) ->

  class EntityStructureObserver extends EntityApplyBasedObserverAbstract

    _setEntity: (args...) ->
      super args...
      @_properties = @_unit._getSchema().getPropertyNames()
      @_storeEntityStructure()

    _storeEntityStructure: ->
      data = (@_storedEntityStructure = {})
      data[ name ] = @_unit[ name ] for name in @_properties

    _isEntityStructureChanged: ->
      data = @_storedEntityStructure or {}
      for name in @_properties when data[ name ] isnt @_unit[ name ]
        return true

    _check: ->
      if @_isEntityStructureChanged()
        _previous = @_storedEntityStructure
        @_storeEntityStructure()
        @emit 'structure', @_storedEntityStructure, _previous
