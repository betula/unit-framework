# @di
di.provider 'EntityChangeBasedObserverAbstract', (UnitObserverAbstract, EntityChangeObserverMixin, EntityObserverMixin) ->

  class EntityChangeBasedObserverAbstract extends UnitObserverAbstract

    @mixins EntityObserverMixin

    _setEntity: ->
      @_bindEntity()

    _bindEntity: ->
      if EntityChangeObserverMixin.hasIn @_unit
        @_addReleaseDelegate @_unit.getChangeObserver().on 'change', @_check.bind @
      else
        @_addReleaseDelegate @_unit.on 'apply', @_check.bind @

    _check: ->
