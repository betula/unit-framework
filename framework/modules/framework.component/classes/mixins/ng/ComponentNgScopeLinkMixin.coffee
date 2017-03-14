# @di
di.provider 'ComponentNgScopeLinkMixin', (MixinAbstract, ComponentNgDescriptorMixin, ComponentNgExportMixin, ComponentNgInjectMixin) ->

  class ComponentNgScopeLinkMixin extends MixinAbstract

    @dependencies ComponentNgDescriptorMixin, ComponentNgExportMixin, ComponentNgInjectMixin

    _preLink: ->
      ComponentNgScopeLinkMixin.super @, '_preLink'
      @_linkScopeDestroy()

    _linkScopeDestroy: ->
      @_getScope().$on '$destroy', => @destroy()


