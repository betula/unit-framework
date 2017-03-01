# @di
di.provider 'EntityObjectMixin', (MixinAbstract, EntitySchemaMixin, UnitObjectMixin) ->

  class EntityObjectMixin extends MixinAbstract

    @dependencies EntitySchemaMixin, UnitObjectMixin

    toObject: ->
      result = {}
      for name in @_getSchema().getPropertyNames()
        result[ name ] = @[ name ]
      return result

