# @di
di.provider 'ComponentReactRenderMixin', (MixinAbstract, debug, ComponentReactContextMixin, ComponentReactTemplateMixin) ->
  log = debug.ns 'ComponentReactRenderMixin'

  class ComponentReactRenderMixin extends MixinAbstract

    @dependencies ComponentReactContextMixin, ComponentReactTemplateMixin

    @allowRenderWithNestedComponents: (@_allowRenderWithNestedComponents = true)->

    @_isAllowRenderWithNestedComponents: ->
      context = @
      while context
        return context._allowRenderWithNestedComponents if context._allowRenderWithNestedComponents?
        context = context.prototype.__proto__?.constructor

      return false

    _checkRenderAllowed: ->
      template = @_getTemplate()

      allowed = true
      if not @constructor._isAllowRenderWithNestedComponents() and template.__nestedComponents?.length > 0
        log.error "Component `#{@constructor.name}` can not be rendered. Use @allowRenderWithNestedComponents() if you want it anyway."
        allowed = false

      return allowed

    render: ->
      @_getReactContext().forceUpdate()

    _getRenderedTemplate: ->
      if @_checkRenderAllowed()
        return @_getTemplate().call @
      else
        return null
