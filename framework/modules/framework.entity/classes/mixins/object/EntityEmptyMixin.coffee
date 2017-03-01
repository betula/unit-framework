# @di
di.provider 'EntityEmptyMixin', (MixinAbstract, EntityDataMixin, lodash) ->

  class EntityEmptyMixin extends MixinAbstract

    @dependencies EntityDataMixin

    getEmptyData: ->
      @__storedEmptyData ?= (new @constructor).getData()
      return lodash.cloneDeep @__storedEmptyData

    setEmptyData: ->
      @setData @getEmptyData()

    isDataEmpty: ->
      lodash.isEqual @getData(), @__storedEmptyData or @getEmptyData()

