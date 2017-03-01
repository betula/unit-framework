# @di
di.provider 'CountedSwitchMixin', (MixinAbstract, EventEmitterMixin, debug) ->
  log = debug.ns 'CountedSwitchMixin'

  class CountedSwitchMixin extends MixinAbstract

    @dependencies EventEmitterMixin

    _getSwitchCounter: ->
      @__switchCounter ?= 0

    _setSwitchCounter: (value) ->
      @__switchCounter = value

    switchOn: ->
      @emit 'switchOn' unless ( counter = @_getSwitchCounter() )
      @_setSwitchCounter counter + 1

    switchOff: ->
      return unless ( counter = @_getSwitchCounter() )
      @_setSwitchCounter --counter
      @emit 'switchOff' unless counter

    isSwitchedOn: ->
      @_getSwitchCounter() > 0

    switchReset: ->
      counter = @_getSwitchCounter()
      @_setSwitchCounter 0
      @emit 'switchOff' if counter
