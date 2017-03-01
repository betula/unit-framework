# @di
di.provider 'EntityStructureObserverMixin', (MixinAbstract, UnitApplyMixin, EntityStructureObserver) ->

  class EntityStructureObserverMixin extends MixinAbstract

    @dependencies UnitApplyMixin

    getStructureObserver: ->
      return @__structureObserver ?= new EntityStructureObserver @

    hasStructureObserver: ->
      return @__structureObserver?
