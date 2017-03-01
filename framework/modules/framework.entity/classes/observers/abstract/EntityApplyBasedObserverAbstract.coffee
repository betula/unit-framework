# @di
di.provider 'EntityApplyBasedObserverAbstract', (UnitApplyBasedObserverAbstract, EntityObserverMixin) ->

  class EntityApplyBasedObserverAbstract extends UnitApplyBasedObserverAbstract

    @mixins EntityObserverMixin
