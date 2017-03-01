# @di
di.provider 'UnitCollectionObserverMixin', (MixinAbstract, UnitApplyMixin, UnitCollectionMixin, UnitCollectionObserver) ->

  class UnitCollectionObserverMixin extends MixinAbstract

    @dependencies UnitApplyMixin, UnitCollectionMixin

    getCollectionObserver: ->
      return @__collectionObserver ?= new UnitCollectionObserver @

    hasCollectionObserver: ->
      return @__collectionObserver?
