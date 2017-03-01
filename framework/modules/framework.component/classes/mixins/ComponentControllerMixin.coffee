# @di
di.provider 'ComponentControllerMixin', (MixinAbstract, ComponentDirectiveMixin, ComponentInjectMixin) ->

  class ComponentControllerMixin extends MixinAbstract

    @dependencies ComponentDirectiveMixin, ComponentInjectMixin

    _getElementController: (name) ->
      @_getElement().controller name
