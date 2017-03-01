# @di
di.provider 'EntityChangeObserver', (EntityApplyBasedObserverAbstract, EntityObserverDataMixin) ->

  class EntityChangeObserver extends EntityApplyBasedObserverAbstract

    @mixins EntityObserverDataMixin

    _setEntity: (args...) ->
      super args...
      @_storeEntityData()

    _check: ->
      if @_isEntityDataChanged()
        @_storeEntityData()
        @emit 'change'
