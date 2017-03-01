# @di
di.provider 'unitDestroyerService', (nextTick, UnitDestroyMixin) ->

  new class UnitDestroyerService
    constructor: ->
      @_collection = []

    add: (unit) ->
      return unless UnitDestroyMixin.hasIn unit
      @_collection.push unit
      @_tickStart()

    _tickStart: ->
      return if @_tickPhase
      @_tickPhase = true
      nextTick @_tickPerform.bind @

    _tickPerform: ->
      @_tickPhase = false
      collection = @_collection.slice()
      @_collection.length = 0

      for unit in collection when unit.getBindCounter() is 0
        unit.destroy()

      if @_collection.length isnt 0
        @_tickStart()

