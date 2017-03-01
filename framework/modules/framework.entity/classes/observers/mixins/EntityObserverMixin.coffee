# @di
di.provider 'EntityObserverMixin', (MixinAbstract) ->

  class EntityObserverMixin extends MixinAbstract

    _setUnit: (args...) ->
      EntityObserverMixin.super @, '_setUnit', args...
      @_setEntity args...

    _setEntity: ->
