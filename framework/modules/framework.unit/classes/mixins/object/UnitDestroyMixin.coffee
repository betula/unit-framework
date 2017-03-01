# @di
di.provider 'UnitDestroyMixin', (MixinAbstract, EventEmitterMixin, UnitBindMixin, MixedMap, injector) ->

  class UnitDestroyMixin extends MixinAbstract

    @dependencies EventEmitterMixin, UnitBindMixin

    _addUnitBinding: (unit) ->
      UnitDestroyMixin.super @, '_addUnitBinding', unit
      if UnitDestroyMixin.hasIn unit
        @_addUnitReleaseDelegate unit, unit.on 'destroy', =>
          @_unBindUnit unit
        @_addUnitReleaseDelegate unit, @on 'destroy', =>
          @_unBindUnit unit

    _releaseUnitBinding: (unit) ->
      UnitDestroyMixin.super @, '_releaseUnitBinding', unit
      @_releaseUnitReleaseDelegates unit

    _decBindCounter: ->
      UnitDestroyMixin.super @, '_decBindCounter'
      if @_getBindCounter() is 0
        destroyer = injector.get 'unitDestroyerService'
        destroyer.add @

    _destroy: ->
      @_isDestoyed = true

    destroy: ->
      @emit 'destroy'
      @_release()
      @_destroy()

    _addUnitReleaseDelegate: (unit, delegate) ->
      map = (@__unitReleaseDelegates ?= new MixedMap)
      map.set unit, (delegates = []) unless (delegates = map.get unit)?
      delegates.push delegate

    _releaseUnitReleaseDelegate: (unit, delegate) ->
      if (map = @__unitReleaseDelegates) and (delegates = map.get unit)
        for _delegate, index in delegates when delegate is _delegate
          (delegates.splice index, 1)[ 0 ]?()
          break
        map.delete unit if delegates.length is 0

    _releaseUnitReleaseDelegates: (unit) ->
      if (map = @__unitReleaseDelegates) and (delegates = map.get unit)
        delegate?() for delegate in delegates
        delegates.length = 0
        map.delete unit

    _addReleaseDelegate: (args...) ->
      (@__releaseDelegates ?= []).push args...

    _release: ->
      map = @__unitReleaseDelegates
      if map
        for delegates in map.values()
          delegate?() for delegate in delegates
          delegates.length = 0
        map.clear()

      if delegates = @__releaseDelegates
        delegate?() for delegate in delegates
        delegates.length = 0

      @_removeListeners()


