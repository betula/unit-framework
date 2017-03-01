# @di
di.provider 'EntitySetPropertyApplyMixin', (MixinAbstract, EntityDataMixin, EntitySchemaMixin, UnitInitMixin, UnitBindMixin, UnitDestroyMixin, UnitApplyMixin, EntitySetPropertyMixin) ->

  class EntitySetPropertyApplyMixin extends MixinAbstract

    @dependencies EntitySetPropertyMixin, UnitApplyMixin

    setProperty: (args...) ->
      @_applyLock()
      EntitySetPropertyApplyMixin.super @, 'setProperty', args...
      @_applyUnLock()
      @apply()

    reSetProperty: (args...) ->
      EntitySetPropertyApplyMixin.super @, 'reSetProperty', args...
      @apply()

    reSetProperties: (args...) ->
      @_applyLock()
      EntitySetPropertyApplyMixin.super @, 'reSetProperties', args...
      @_applyUnLock()
      @apply()
