# @di
di.provider 'ComponentInitApplyMixin', (MixinAbstract, UnitInitMixin, UnitApplyMixin) ->

  class ComponentInitApplyMixin extends MixinAbstract

    @dependencies UnitInitMixin, UnitApplyMixin

    _afterInit: ->
      @apply()
