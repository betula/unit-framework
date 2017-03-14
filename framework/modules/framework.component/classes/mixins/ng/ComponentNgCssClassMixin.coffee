# @di
di.provider 'ComponentNgCssClassMixin', (MixinAbstract, ComponentNgDescriptorMixin, ComponentNgInjectMixin) ->

  class ComponentNgCssClassMixin extends MixinAbstract

    @dependencies ComponentNgDescriptorMixin, ComponentNgInjectMixin

    @cssClass: (@_cssClass) ->

    _cssClass: ->

    _preLink: ->
      ComponentNgCssClassMixin.super @, '_preLink'

      element = @_getElement()

      if @constructor._cssClass is '@'
        element.addClass _class if (_class = @_cssClass?())
      else if @constructor._cssClass
        element.addClass if Array.isArray @constructor._cssClass then @constructor._cssClass.join ' ' else @constructor._cssClass
