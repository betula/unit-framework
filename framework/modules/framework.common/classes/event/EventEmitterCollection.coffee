# @di
di.provider 'EventEmitterCollection', (MixableCollectionAbstract, EventEmitterMixin) ->

  class EventEmitterCollection extends MixableCollectionAbstract
    @mixins EventEmitterMixin
