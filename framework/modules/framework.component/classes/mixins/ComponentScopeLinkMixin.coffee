# @di
di.provider 'ComponentScopeLinkMixin', (MixinAbstract, ComponentDirectiveMixin, ComponentExportMixin, ComponentInjectMixin) ->

  class ComponentScopeLinkMixin extends MixinAbstract

    @dependencies ComponentDirectiveMixin, ComponentExportMixin, ComponentInjectMixin

    _preLink: ->
      ComponentScopeLinkMixin.super @, '_preLink'

      @_linkScopeDestroy()
      @_exportToScope()

    _linkScopeDestroy: ->
      @_getScope().$on '$destroy', => @destroy()

    _exportToScope: ->
      @_export @_getScope()
