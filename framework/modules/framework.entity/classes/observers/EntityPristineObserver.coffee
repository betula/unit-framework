# @di
di.provider 'EntityPristineObserver', (EntityChangeBasedObserverAbstract, EntityObserverDataMixin) ->

  class EntityPristineObserver extends EntityChangeBasedObserverAbstract

    @mixins EntityObserverDataMixin

    _setEntity: (args...) ->
      super args...
      @_storeEntityData()
      @_pristine = true

    _check: ->
      if @_isEntityDataChanged()
        @_setDirty()
      else
        @_setPristine()

    _setDirty: ->
      if @_pristine
        @_pristine = false
        @emit 'dirty'

    _setPristine: ->
      unless @_pristine
        @_storeEntityData()
        @_pristine = true
        @emit 'pristine'

    setDirty: ->
      @_setDirty()

    setPristine: ->
      @_setPristine()

    isPristine: ->
      return @_pristine

    isDirty: ->
      return not @_pristine

    getPristineData: ->
      return @_storedEntityData
