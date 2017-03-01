# @di
di.provider 'ComponentCssClassMixin', (MixinAbstract, ComponentDirectiveMixin, ComponentInjectMixin) ->

  class ComponentCssClassMixin extends MixinAbstract

    @dependencies ComponentDirectiveMixin, ComponentInjectMixin

    @cssClass: (@_cssClass) ->

    _cssClass: ->

    _preLink: ->
      ComponentCssClassMixin.super @, '_preLink'

      element = @_getElement()

      if @constructor._cssClass is '@'
        element.addClass _class if (_class = @_cssClass?())
      else if @constructor._cssClass
        element.addClass if Array.isArray @constructor._cssClass then @constructor._cssClass.join ' ' else @constructor._cssClass
