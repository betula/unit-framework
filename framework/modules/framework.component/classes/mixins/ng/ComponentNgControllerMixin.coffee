# @di
di.provider 'ComponentNgControllerMixin', (MixinAbstract, ComponentNgDescriptorMixin, ComponentNgInjectMixin) ->

  class ComponentNgControllerMixin extends MixinAbstract

    @dependencies ComponentNgDescriptorMixin, ComponentNgInjectMixin

    _getElementController: (name) ->
      @_getElement().controller name
