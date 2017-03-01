# @di
di.provider 'EventEmitter', (MixableAbstract, EventEmitterMixin) ->

  class EventEmitter extends MixableAbstract
    @mixins EventEmitterMixin
