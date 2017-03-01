# @di
di.provider 'UnitActivityWatcher', (UnitAbstract, CountedSwitchMixin, CountedSwitch, UnitDestroyMixin, Q) ->

  class UnitActivityWatcher extends UnitAbstract

    _init: ->
      super()
      @active = false
      @inactive = true

    _getSwitch: ->
      unless @__switch
        @_bind @__switch = new CountedSwitch()

        @_listen @__switch, 'switchOn', =>
          @active = true
          @inactive = false
          @emit 'active'
          @apply()

        @_listen @__switch, 'switchOff', =>
          @active = false
          @inactive = true
          @emit 'inactive'
          @apply()

      return @__switch

    add: (values...) ->
      _switcher = @_getSwitch()

      for value in values
        if value instanceof UnitActivityWatcher
          _switcher.switchOn() if value.active
          @_listen value, 'active', -> _switcher.switchOn()
          @_listen value, 'inactive', -> _switcher.switchOff()

          if UnitDestroyMixin.hasIn value
            @_listen value, 'destroy', ->
              if value.active
                _switcher.switchOff()

        else if CountedSwitchMixin.hasIn value
          _switcher.switchOn() if value.isSwitchedOn()
          @_listen value, 'switchOn', -> _switcher.switchOn()
          @_listen value, 'switchOff', -> _switcher.switchOff()

          if UnitDestroyMixin.hasIn value
            @_listen value, 'destroy', ->
              if value.isSwitchedOn()
                _switcher.switchOff()

        else if value is on
          _switcher.switchOn()

        else if value is off
          _switcher.switchOff()

        else if value and typeof value.then is 'function'
          do (value) =>
            canceled = false
            silent = true
            resolved = false

            value.finally =>
              resolved = true
              @_getSwitch().switchOff() unless silent or canceled

            silent = false
            _switcher.switchOn() unless resolved

            @on 'destroy', ->
              canceled = true

    reset: ->
      @_getSwitch().switchReset()

    getInactivePromise: ->
      return Q.resolve() unless @_getSwitch().isSwitchedOn()

      deferred = Q.defer()
      @once 'inactive', -> deferred.resolve()
      return deferred.promise

    getActivePromise: ->
      return Q.resolve() if @_getSwitch().isSwitchedOn()

      deferred = Q.defer()
      @once 'active', -> deferred.resolve()
      return deferred.promise
