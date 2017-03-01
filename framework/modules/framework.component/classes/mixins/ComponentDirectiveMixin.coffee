# @di
di.provider 'ComponentDirectiveMixin', (debug, MixinAbstract, ComponentInjectMixin, UnitInitMixin) ->
  log = debug.ns 'ComponentDirectiveMixin'

  class ComponentDirectiveMixin extends MixinAbstract

    @dependencies ComponentInjectMixin, UnitInitMixin

    @getDirectiveDescriptor: ->
      descriptor = {}
      descriptor.restrict = @_restrict
      descriptor.template = @_template if @_template?
      descriptor.templateUrl = @_templateUrl if @_templateUrl?
      descriptor.compile = @_compile.bind @
      descriptor.controller = [ @_getInject()..., @ ]
      unless @_scope is null
        descriptor.scope = if typeof @_scope is 'undefined' then {} else @_scope

      keys = [
        'multiElement'
        'transclude'
        'priority'
        'terminal'
      ]
      for key in keys when @[ (_key = "_#{key}") ]?
        descriptor[ key ] = @[ _key ]

      return descriptor

    @_compile: ->
      pre: @_preLink.bind @
      post: @_postLink.bind @

    @_preLink: (scope, element, attrs, instance) ->
      instance._preLink()

    @_postLink:  (scope, element, attrs, instance) ->
      instance._postLink()

    _preLink: ->
      try
        @_preInit()
        @_init()
        @_afterInit()
      catch e
        log.error e

    _postLink: ->
