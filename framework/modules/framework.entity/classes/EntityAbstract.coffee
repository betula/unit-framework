# @di
di.provider 'EntityAbstract', (
  UnitAbstract
  EntityMixin
  EntitySchemaMixin
  EntityObjectMixin
  EntityDataMixin
  EntitySetPropertyMixin
  EntityPristineMixin
  EntityDataApplyMixin
  EntitySetPropertyApplyMixin
  EntityEmptyMixin
  EntityChangeObserverMixin
  EntityPristineObserverMixin
  EntityStructureObserverMixin
  EntityEmptyObserverMixin
  EntityCloneMixin
) ->

  class EntityAbstract extends UnitAbstract

    @mixins [
      EntityMixin
      EntitySchemaMixin
      EntityObjectMixin
      EntityDataMixin
      EntitySetPropertyMixin
      EntityDataApplyMixin
      EntitySetPropertyApplyMixin
      EntityPristineObserverMixin
      EntityPristineMixin
      EntityEmptyMixin
      EntityChangeObserverMixin
      EntityStructureObserverMixin
      EntityEmptyObserverMixin
      EntityCloneMixin
    ]

