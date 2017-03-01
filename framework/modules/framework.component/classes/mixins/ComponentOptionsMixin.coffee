# @di
di.provider 'ComponentOptionsMixin', (MixinAbstract) ->

  class ComponentOptionsMixin extends MixinAbstract

    @restrict: (@_restrict) ->
      @_restrict or= 'E'

    @template: (@_template) ->
    @templateUrl: (@_templateUrl) ->

    @scope: (value) ->
      if value is 'isolate' or value?.constructor is Object
        @_scope = {}
      else if value or arguments.length is 0
        @_scope = true
      else
        @_scope = null

    @scopeIsolate: (value) ->
      @scope if value or arguments.length is 0 then {} else true

    @noScope: ->
      @scope null

    @options: (config = {}) ->
      keys = [
        'multiElement'
        'transclude'
        'priority'
        'terminal'
        'scope'
        'restrict'
        'template'
        'templateUrl'
      ]
      for key in keys when config.hasOwnProperty key
        @[ "_#{key}" ] = config[ key ] ? null

