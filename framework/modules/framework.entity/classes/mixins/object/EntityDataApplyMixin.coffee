# @di
di.provider 'EntityDataApplyMixin', (MixinAbstract, EntityDataMixin, UnitApplyMixin) ->

  class EntityDataApplyMixin extends MixinAbstract

    @dependencies EntityDataMixin, UnitApplyMixin

    setData: (args...) ->
      @_applyLock()
      EntityDataApplyMixin.super @, 'setData', args...
      @_applyUnLock()
      @apply()
