# @di
di.provider 'ComponentReactDescriptorMixin', (debug, MixinAbstract, UnitMixin, React) ->
  log = debug.ns 'ComponentReactDescriptorMixin'

  class ComponentReactDescriptorMixin extends MixinAbstract

    @dependencies UnitMixin

    @getComponentDescriptor: ->
      instance = null
      Component = @

      componentWillMount: ->
        instance = new Component @

      componentWillUnmount: ->
        instance.destroy()

      render: ->
        instance._getRenderedTemplate()
