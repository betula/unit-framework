# @di
di.provider 'ComponentReactContextMixin', (MixinAbstract) ->

  class ComponentReactContextMixin extends MixinAbstract

    _setReactContext: (@_reactContext) ->

    _getReactContext: ->
      @_reactContext
