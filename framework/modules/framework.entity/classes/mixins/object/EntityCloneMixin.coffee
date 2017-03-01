# @di
di.provider 'EntityCloneMixin', (MixinAbstract, EntityDataMixin) ->

  class EntityCloneMixin extends MixinAbstract

    @dependencies EntityDataMixin

    clone: ->
      new @constructor @getData()

