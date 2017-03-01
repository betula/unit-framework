# @di
di.provider 'UnitListenMixin', (MixinAbstract, EventEmitterMixin, UnitDestroyMixin, debug) ->
  log = debug.ns 'UnitListenMixin'

  class UnitListenMixin extends MixinAbstract

    @dependencies UnitDestroyMixin

    _listen: (unit, event, listener, context = @) ->
      if EventEmitterMixin.hasIn unit
        _releaseDelegate = unit.on event, listener.bind context
        @_addUnitReleaseDelegate unit, _releaseDelegate
        if UnitDestroyMixin.hasIn unit
          @_addUnitReleaseDelegate unit, unit.on 'destroy', =>
            @_releaseUnitReleaseDelegates unit

        return =>
          @_releaseUnitReleaseDelegate unit, _releaseDelegate
      else
        msg = 'Unsupported listen object'
        log.error msg
        throw new Error msg

