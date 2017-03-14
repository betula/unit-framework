# @di
di.provider 'ComponentNgAbstract', (
  EventEmitter
  UnitMixin
  UnitInitMixin
  UnitBindMixin
  UnitDestroyMixin
  UnitObjectMixin
  UnitApplyMixin
  UnitListenMixin
  UnitListenElementMixin
  ComponentNgInjectMixin
  ComponentNgOptionsMixin
  ComponentNgDescriptorMixin
  ComponentNgControllerMixin
  ComponentNgInputMixin
  ComponentNgExportMixin
  ComponentNgCssClassMixin
  ComponentNgInitApplyMixin
  ComponentNgPendingMixin
  ComponentNgScopeLinkMixin
) ->

  class ComponentNgAbstract extends EventEmitter

    @mixins [
      UnitMixin
      UnitInitMixin
      UnitBindMixin
      UnitDestroyMixin
      UnitObjectMixin
      UnitApplyMixin
      UnitListenMixin
      UnitListenElementMixin
      ComponentNgInjectMixin
      ComponentNgOptionsMixin
      ComponentNgDescriptorMixin
      ComponentNgControllerMixin
      ComponentNgInputMixin
      ComponentNgExportMixin
      ComponentNgCssClassMixin
      ComponentNgInitApplyMixin
      ComponentNgPendingMixin
      ComponentNgScopeLinkMixin
    ]

    constructor: (inject...) ->
      @_inject inject...
      super()
