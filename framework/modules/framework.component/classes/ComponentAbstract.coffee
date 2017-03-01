# @di
di.provider 'ComponentAbstract', (
  EventEmitter
  UnitMixin
  UnitInitMixin
  UnitBindMixin
  UnitDestroyMixin
  UnitObjectMixin
  UnitApplyMixin
  UnitListenMixin
  UnitListenElementMixin
  ComponentInjectMixin
  ComponentOptionsMixin
  ComponentDirectiveMixin
  ComponentControllerMixin
  ComponentExportMixin
  ComponentInputMixin
  ComponentCssClassMixin
  ComponentInitApplyMixin
  ComponentPendingMixin
  ComponentScopeLinkMixin
) ->

  class ComponentAbstract extends EventEmitter

    @mixins [
      UnitMixin
      UnitInitMixin
      UnitBindMixin
      UnitDestroyMixin
      UnitObjectMixin
      UnitApplyMixin
      UnitListenMixin
      UnitListenElementMixin
      ComponentInjectMixin
      ComponentOptionsMixin
      ComponentDirectiveMixin
      ComponentControllerMixin
      ComponentExportMixin
      ComponentInputMixin
      ComponentCssClassMixin
      ComponentInitApplyMixin
      ComponentPendingMixin
      ComponentScopeLinkMixin
    ]

    constructor: (inject...) ->
      @_inject inject...
      super()
