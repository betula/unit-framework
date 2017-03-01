# @di
di.provider 'UnitApplyBasedObserverAbstract', (UnitObserverAbstract) ->

  class UnitApplyBasedObserverAbstract extends UnitObserverAbstract

    _setUnit: (args...) ->
      super args...
      @_bindUnit()

    _bindUnit: ->
      @_addReleaseDelegate @_unit.on 'apply', @_check.bind @

    _check: ->
