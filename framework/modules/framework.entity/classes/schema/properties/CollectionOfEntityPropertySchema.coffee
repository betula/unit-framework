# @di
di.provider 'CollectionOfEntityPropertySchema', (debug, EntityPropertySchemaAbstract, EntityCollectionSchemaMixin, EntityPropertySchemaFactory, MixableCollectionAbstract) ->
  log = debug.ns 'CollectionOfEntityPropertySchema'

  class CollectionOfEntityPropertySchema extends EntityPropertySchemaAbstract

    constructor: (options = {}) ->
      super options

      @_collection = EntityPropertySchemaFactory if options.collection? then options.collection else MixableCollectionAbstract
      @_of = if options.of? then EntityPropertySchemaFactory options.of

      _super = @_collection._type or MixableCollectionAbstract
      _of = @_of

      unless _super is MixableCollectionAbstract or (_super::) instanceof MixableCollectionAbstract
        _of = @_of = null
        _name = options.collection
        _name = _name.name if typeof _name is 'function'
        log.error "#{_name} unsupported. Collection type must be inherit from MixableCollectionAbstract"

      @_type = class extends _super
        if _of?
          @mixins EntityCollectionSchemaMixin unless EntityCollectionSchemaMixin.hasInClass _super
          @of _of

    _parse: (data) ->
      return super @_collection._parse data

    _pass: (value) ->
      return false unless @_collection.pass value
      if @_of
        return false unless EntityCollectionSchemaMixin.hasIn value
        return false if value._getCollectionSchema()._type isnt @_of._type
      return true
