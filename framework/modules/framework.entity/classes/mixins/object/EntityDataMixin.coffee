# @di
di.provider 'EntityDataMixin', (MixinAbstract, EntitySchemaMixin, UnitInitMixin, UnitBindMixin) ->

  class EntityDataMixin extends MixinAbstract

    @dependencies UnitInitMixin, EntitySchemaMixin, UnitBindMixin

    _afterInit: (args...) ->
      EntityDataMixin.super @, '_afterInit', args...
      @setData args...

    _setData: (data = {}) ->
      for name, property of @_getSchema().getProperties() when data.hasOwnProperty name
        if @[ name ]? and EntityDataMixin.hasIn @[ name ]
          @[ name ].setData data[ name ]
        else
          @_bind @[ name ] = property.cast data[ name ]

    _getData: ->
      data = {}
      for name, property of @_getSchema().getProperties()
        if @[ name ]? and EntityDataMixin.hasIn @[ name ]
          data[ name ] = @[ name ].getData()
        else
          data[ name ] = property.format @[ name ]
      return data

    setData: (data, args...) ->
      if arguments.length is 0
        @_setData()
      else if data isnt this
        @_setData data, args...

    getData: ->
      return @_getData()

    toJSON: ->
      return @getData()

