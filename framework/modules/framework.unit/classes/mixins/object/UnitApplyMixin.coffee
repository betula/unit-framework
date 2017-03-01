# @di
di.provider 'UnitApplyMixin', (MixinAbstract, UnitInitMixin, UnitBindMixin, UnitDestroyMixin) ->

  class UnitApplyMixin extends MixinAbstract

    @dependencies UnitInitMixin, UnitBindMixin, UnitDestroyMixin

    _addUnitBinding: (unit) ->
      UnitApplyMixin.super @, '_addUnitBinding', unit
      @_addUnitReleaseDelegate unit, unit.on 'apply', @apply.bind @
      @_addUnitReleaseDelegate unit, unit.on 'applyBegin', @applyBegin.bind @
      @_addUnitReleaseDelegate unit, unit.on 'applyEnd', @applyEnd.bind @

    _afterInit: (args...) ->
      UnitApplyMixin.super @, '_afterInit', args...
      @__initialized = true
      @apply()

    _applyLock: ->
      @__applyLockCounter ?= 0
      @__applyLocked = true if (++ @__applyLockCounter) is 1

    _applyUnLock: ->
      @__applyLocked = false if (-- @__applyLockCounter) is 0

    apply: ->
      if @__initialized and not @__applyLocked
        @emit 'apply'

    applyBegin: ->
      @__applyPhaseCounter ?= 0
      if (++ @__applyPhaseCounter) is 1
        @_applyLock()
        @emit 'applyBegin'

    applyEnd: ->
      if (-- @__applyPhaseCounter) is 0
        @_applyUnLock()
        @apply()
        @emit 'applyEnd'
