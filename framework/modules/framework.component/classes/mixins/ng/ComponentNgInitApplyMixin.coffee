# @di
di.provider 'ComponentNgInitApplyMixin', (MixinAbstract, UnitInitMixin, UnitApplyMixin) ->

  class ComponentNgInitApplyMixin extends MixinAbstract

    @dependencies UnitInitMixin, UnitApplyMixin

    _afterInit: ->
      ComponentNgInitApplyMixin.super @, '_afterInit'
      @apply()
