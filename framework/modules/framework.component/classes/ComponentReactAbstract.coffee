# @di
di.provider 'ComponentReactAbstract', (
  EventEmitter
  UnitMixin
  UnitInitMixin
  UnitBindMixin
  UnitDestroyMixin
  UnitListenMixin
  UnitListenElementMixin
  ComponentReactContextMixin
  ComponentReactTemplateMixin
  ComponentReactDescriptorMixin
  ComponentReactInputMixin
  ComponentReactPendingMixin
  ComponentReactRenderMixin
  ComponentReactChildrenMixin
) ->

  class ComponentReactAbstract extends EventEmitter

    @mixins [
      UnitMixin
      UnitInitMixin
      UnitBindMixin
      UnitDestroyMixin
      UnitListenMixin
      UnitListenElementMixin
      ComponentReactContextMixin
      ComponentReactTemplateMixin
      ComponentReactDescriptorMixin
      ComponentReactInputMixin
      ComponentReactPendingMixin
      ComponentReactRenderMixin
      ComponentReactChildrenMixin
    ]

    constructor: (context) ->
      super()
      @_setReactContext context
      @_preInit()
      @_init()
      @_afterInit()

