# @di
di.provider 'UnitCollectionSortByMixin', (MixinAbstract, UnitCollectionApplyMixin) ->

  class UnitCollectionSortByMixin extends MixinAbstract

    @dependencies UnitCollectionApplyMixin

    sortBy: (getter, asc = true, nullAtTail = true) ->

      if typeof getter is 'string'
        prop = getter
        getter = (value) -> value[ prop ]

      ascSortDirection = if asc then -1 else 1
      nullSortDirection = if nullAtTail then 1 else -1

      @sort (first, second) =>
        _first = getter first
        _second = getter second

        if not _first? or not _second?
          return nullSortDirection if not _first?
          return -nullSortDirection if not _second?
          return 0 if not _first? and not _second?

        return -ascSortDirection if _first > _second
        return ascSortDirection if _first < _second
        return 0
