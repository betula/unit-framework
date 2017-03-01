# @di
di.provider 'EntityCollectionPristineMixin', (MixinAbstract, EntityPristineMixin) ->

  class EntityCollectionPristineMixin extends MixinAbstract

    @dependencies EntityPristineMixin

    _setPristine: ->
      for value in @ when EntityPristineMixin.hasIn value
        value.setPristine()

      EntityCollectionPristineMixin.super @, '_setPristine'
