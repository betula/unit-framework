# @di
di.provider 'EntityChangeObserverMixin', (MixinAbstract, UnitApplyMixin, EntityChangeObserver) ->

  class EntityChangeObserverMixin extends MixinAbstract

    @dependencies UnitApplyMixin

    getChangeObserver: ->
      return @__changeObserver ?= new EntityChangeObserver @

    hasChangeObserver: ->
      return @__changeObserver?

