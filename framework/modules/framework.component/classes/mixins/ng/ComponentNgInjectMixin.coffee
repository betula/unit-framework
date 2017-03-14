# @di
di.provider 'ComponentNgInjectMixin', (MixinAbstract) ->

  class ComponentNgInjectMixin extends MixinAbstract

    @_getInject: -> [
      '$scope'
      '$element'
      '$attrs'
      '$transclude'
    ]

    _getScope: ->
      @__inject.$scope

    _getElement: ->
      @__inject.$element

    _getAttrs: ->
      @__inject.$attrs

    _getTransclude: ->
      @__inject.$transclude

    _inject: (inject...) ->
      @__inject = {}
      for name, index in @constructor._getInject()
        @__inject[ name ] = inject[ index ]
