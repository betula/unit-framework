# @di
di.provider 'EntityEmptyObserverMixin', (MixinAbstract, UnitApplyMixin, EntityEmptyObserver) ->

  class EntityEmptyObserverMixin extends MixinAbstract

    @dependencies UnitApplyMixin

    getEmptyObserver: ->
      return @__emptyObserver ?= new EntityEmptyObserver @

    hasEmptyObserver: ->
      return @__emptyObserver?
