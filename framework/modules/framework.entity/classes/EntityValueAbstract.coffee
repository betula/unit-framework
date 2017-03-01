# @di
di.provider 'EntityValueAbstract', (EntityAbstract, EntityValueMixin, EntityValueSchemaMixin) ->

  class EntityValueAbstract extends EntityAbstract

    @mixins EntityValueMixin, EntityValueSchemaMixin
