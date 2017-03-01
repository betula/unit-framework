# @di
di.provider 'UnitCollectionAbstract', (
  EventEmitterCollection
  UnitMixin
  UnitInitMixin
  UnitBindMixin
  UnitDestroyMixin
  UnitApplyMixin
  UnitListenMixin
  UnitListenElementMixin
  UnitCollectionMixin
  UnitCollectionApplyMixin
  UnitCollectionSortByMixin
  UnitCollectionObserverMixin
) ->

  class UnitCollectionAbstract extends EventEmitterCollection

    @mixins [
      UnitMixin
      UnitInitMixin
      UnitBindMixin
      UnitDestroyMixin
      UnitApplyMixin
      UnitListenMixin
      UnitListenElementMixin
      UnitCollectionMixin
      UnitCollectionApplyMixin
      UnitCollectionSortByMixin
      UnitCollectionObserverMixin
    ]

    constructor: (args...) ->
      super()
      @_preInit args...
      @_init args...
      @_afterInit args...
