# @di
di.provider 'UnitAbstract', (
  EventEmitter
  UnitMixin
  UnitInitMixin
  UnitBindMixin
  UnitDestroyMixin
  UnitObjectMixin
  UnitApplyMixin
  UnitListenMixin
  UnitListenElementMixin
) ->

  class UnitAbstract extends EventEmitter

    @mixins [
      UnitMixin
      UnitInitMixin
      UnitBindMixin
      UnitDestroyMixin
      UnitObjectMixin
      UnitApplyMixin
      UnitListenMixin
      UnitListenElementMixin
    ]

    constructor: (args...) ->
      super()
      @_preInit args...
      @_init args...
      @_afterInit args...

