# @di
di.provider 'EntityCollectionAbstract', (
  UnitCollectionAbstract
  EntityMixin
  EntitySchemaMixin
  EntityCollectionMixin
  EntityCollectionSchemaMixin
  EntityCollectionSortMixin
  EntityCollectionIndexMixin
  EntityCollectionMapMixin
  EntityDataMixin
  EntitySetPropertyMixin
  EntityCollectionDataMixin
  EntityDataApplyMixin
  EntitySetPropertyApplyMixin
  EntityCollectionUpsertMixin
  EntityPristineObserverMixin
  EntityPristineMixin
  EntityCollectionPristineMixin
  EntityEmptyMixin
  EntityChangeObserverMixin
  EntityStructureObserverMixin
  EntityEmptyObserverMixin
  EntityCloneMixin
) ->

  class EntityCollectionAbstract extends UnitCollectionAbstract

    @mixins [
      EntityMixin
      EntitySchemaMixin
      EntityCollectionMixin
      EntityCollectionSchemaMixin
      EntityCollectionIndexMixin
      EntityCollectionMapMixin
      EntityDataMixin
      EntitySetPropertyMixin
      EntityDataApplyMixin
      EntitySetPropertyApplyMixin
      EntityCollectionUpsertMixin
      EntityCollectionDataMixin
      EntityCollectionSortMixin
      EntityPristineObserverMixin
      EntityPristineMixin
      EntityCollectionPristineMixin
      EntityEmptyMixin
      EntityChangeObserverMixin
      EntityStructureObserverMixin
      EntityEmptyObserverMixin
      EntityCloneMixin
    ]
