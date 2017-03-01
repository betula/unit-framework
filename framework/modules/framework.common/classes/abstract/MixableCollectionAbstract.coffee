# @di
di.provider 'MixableCollectionAbstract', (MixableAbstract, CollectionAbstract) ->

  class MixableCollectionAbstract extends CollectionAbstract

    @mixins: MixableAbstract.mixins

    @_hasAnyMixin: MixableAbstract._hasAnyMixin
    @_hasAllMixins: MixableAbstract._hasAllMixins
    @_hasMixin: MixableAbstract._hasMixin
