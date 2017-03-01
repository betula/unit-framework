# @di
di.provider 'CountedSwitch', (EventEmitter, CountedSwitchMixin) ->

  class CountedSwitch extends EventEmitter

    @mixins CountedSwitchMixin

