# @di
di.provider 'ComponentReactChildrenMixin', (MixinAbstract, ComponentReactContextMixin) ->

  class ComponentReactChildrenMixin extends MixinAbstract

    @dependencies ComponentReactContextMixin

    children: ->
      @_getReactContext().props.children
