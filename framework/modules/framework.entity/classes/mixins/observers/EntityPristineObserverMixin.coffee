# @di
di.provider 'EntityPristineObserverMixin', (MixinAbstract, UnitApplyMixin, EntityPristineObserver) ->

  class EntityPristineObserverMixin extends MixinAbstract

    @dependencies UnitApplyMixin

    getPristineObserver: ->
      return @__pristineObserver ?= new EntityPristineObserver @

    hasPristineObserver: ->
      return @__pristineObserver?
