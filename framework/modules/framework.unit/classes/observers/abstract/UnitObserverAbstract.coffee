# @di
di.provider 'UnitObserverAbstract', (EventEmitter) ->

  class UnitObserverAbstract extends EventEmitter

    constructor: (unit) ->
      @_setUnit unit

    _setUnit: (@_unit) ->
      @_bindUnitDestroy()

    _bindUnitDestroy: ->
      @_addReleaseDelegate @_unit.on 'destroy', @_release.bind @

    _addReleaseDelegate: (delegate) ->
      (@_releaseDelegates ?= []).push delegate

    _release: ->
      if delegates = @_releaseDelegates
        delegate?() for delegate in delegates
        delegates.length = 0

      @_removeListeners()
