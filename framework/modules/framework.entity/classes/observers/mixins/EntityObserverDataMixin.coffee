# @di
di.provider 'EntityObserverDataMixin', (MixinAbstract, lodash) ->

  class EntityObserverDataMixin extends MixinAbstract

    _storeEntityData: ->
      @_storedEntityData = lodash.cloneDeep @_unit.getData()

    _isEntityDataChanged: ->
      return not lodash.isEqual @_storedEntityData, @_unit.getData()

