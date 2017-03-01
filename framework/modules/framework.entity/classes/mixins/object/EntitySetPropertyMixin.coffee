# @di
di.provider 'EntitySetPropertyMixin', (MixinAbstract, EntitySchemaMixin, UnitBindMixin, EntityDataMixin) ->

  class EntitySetPropertyMixin extends MixinAbstract

    @dependencies EntitySchemaMixin, UnitBindMixin, EntityDataMixin

    setProperty: (name, value) ->
      properties = @_getSchema().getProperties()
      return null unless properties.hasOwnProperty name
      if @[ name ]? and EntityDataMixin.hasIn @[ name ]
        data = {}
        data[ name ] = value
        @[ name ].setData data
      else
        @_bind @[ name ] = properties[ name ].cast value

    reSetProperty: (name, value) ->
      properties = @_getSchema().getProperties()
      return null unless properties.hasOwnProperty name
      @_unBind _value = @[ name ]
      @_bind @[ name ] = properties[ name ].cast value

      return _value

    reSetProperties: (properties = {}) ->
      _result = {}
      for name, value of properties
        _result[ name ] = @reSetProperty name, value
      return _result
