# @di
di.provider 'EntityPristineMixin', (MixinAbstract, EntitySchemaMixin, EntityPristineObserverMixin) ->

  class EntityPristineMixin extends MixinAbstract

    @dependencies EntitySchemaMixin, EntityPristineObserverMixin

    _setPristine: ->
      for name in @_getSchema().getPropertyNames() when @[ name ]? and EntityPristineMixin.hasIn @[ name ]
        @[ name ].setPristine()

      @getPristineObserver().setPristine() if @hasPristineObserver()

    setPristine: ->
      @_setPristine()

    setPristineData: ->
      @setData @getPristineObserver().getPristineData()
