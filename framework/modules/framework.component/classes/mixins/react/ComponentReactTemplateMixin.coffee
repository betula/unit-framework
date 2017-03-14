# @di
di.provider 'ComponentReactTemplateMixin', (MixinAbstract, $injector) ->

  class ComponentReactTemplateMixin extends MixinAbstract

    @template: (name) ->
      @_template = $injector.get "template:#{name}"

    @_getTemplate: ->
      context = @
      while context
        return context._template if context._template?
        context = context.prototype.__proto__?.constructor

      return ->

    _getTemplate: ->
      @constructor._getTemplate()
