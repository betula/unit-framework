# @di
di.provider 'EntityCollectionMixin', (MixinAbstract, UnitCollectionMixin) ->

  class EntityCollectionMixin extends MixinAbstract

    @dependencies UnitCollectionMixin
