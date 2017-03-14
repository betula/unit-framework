# @di
di.provider 'ComponentNgPendingMixin', (MixinAbstract, UnitInitMixin, ComponentNgDescriptorMixin, UnitActivityWatcher, ComponentNgInputMixin, ComponentNgInjectMixin) ->

  capitalize = (str)->
    return str.charAt(0).toUpperCase() + str.slice(1)
      
  class ComponentNgPendingMixin extends MixinAbstract

    @dependencies ComponentNgDescriptorMixin, UnitInitMixin, ComponentNgInputMixin, ComponentNgInjectMixin

    @Defaults =
      PendingKey: 'main'
      PendingIn: '@pendingIn'
      PendingOut: '@pendingOut'
      PendingExport: true

    @pending: (values...)->
      unless @hasOwnProperty '_pendingConfig'
        Object.defineProperty @, '_pendingConfig', value: {}

      gatherDependencies = (value)->
        result = []
        if value?
          if Array.isArray value
            for arrayValue in value
              result.push String arrayValue
          else
            result.push String value
        return result

      registerPending = (key, dependencies)=>
        if dependencies? and typeof dependencies is 'object'
          @_pendingConfig[key] =
            in: gatherDependencies dependencies.in
            out: gatherDependencies dependencies.out
            export: if dependencies.export? then Boolean dependencies.export else @Defaults.PendingExport

      registerPending @Defaults.PendingKey, { in: @Defaults.PendingIn, out: @Defaults.PendingOut, export: @Defaults.PendingExport }
      if values.length
        for value in values when value?
          if typeof value is 'string'
            registerPending value, {}
          else if Array.isArray value
            for arrayValue in value
              if typeof arrayValue is 'string'
                registerPending arrayValue, {}
              else
                for key, dependencies of arrayValue
                  registerPending key, dependencies
          else if typeof value is 'object'
            for key, dependencies of value
              registerPending key, dependencies

      pendingInput = {}
      pendingConstraints = {}

      constructPending = (key = '', dependencies = { in: [], out: [] })=>
        Object.defineProperty @prototype, 'pending' + capitalize(key),
          get: ->
            @_getPending key || null
          configurable: true

        @prototype[ '_setPending' + capitalize key ] = (values...) ->
          if key is '' and typeof values[0] is 'string'
            context = @_getPending(values[0] || null)
            context.add.apply context, values.slice(1)
          else
            @_getPending(key || null).add values...

        for _key in dependencies.in when _key.charAt(0) is '@'
          _key = _key.slice(1)
          if _key
            pendingInput[ _key ] = '='
            pendingConstraints[ _key ] = [ UnitActivityWatcher, null ]
            @prototype[ 'set' + capitalize _key ] = (value) ->
              @_getPending(key).add value

        for _key in dependencies.out when _key.charAt(0) is '@'
          _key = _key.slice(1)
          if _key
            pendingInput[ _key ] = '='
            pendingConstraints[ _key ] = [ UnitActivityWatcher, null ]
            @prototype[ 'set' + capitalize _key ] = (value) ->
              if value instanceof UnitActivityWatcher
                value.add @_getPending(key)

      constructPending()
      for key, value of @_getPendingConfig()
        constructPending(key, value)

      @input pendingInput

      @constraints pendingConstraints

    @_getPendingConfig: ->
      unless @prototype.hasOwnProperty '_pendingConfigCache'
        list = []
        context = @
        while context
          list.push context._pendingConfig if context._pendingConfig?
          context = context.prototype.__proto__?.constructor

        config = {}
        for _config in list.reverse()
          for own key, value of _config
            config[ key ] = value

        Object.defineProperty @prototype, '_pendingConfigCache',
          value: config
      return @prototype._pendingConfigCache

    _getPendingConfig: ->
      @constructor._getPendingConfig()

    _hasPending: ->
      return Object.keys( @_getPendingConfig() ).length

    _preInit: (args...) ->
      ComponentNgPendingMixin.super @, '_preInit', args...

      @_initPendings()
      @_exportPendings()

    _initPendings: ->
      @__pendingStates = {}
      config = @_getPendingConfig()

      for key of config
        unless @__pendingStates.hasOwnProperty key
          @_bind @__pendingStates[ key ] = new UnitActivityWatcher

      for key of config
        for keyOut in config[key].out when keyOut.charAt(0) isnt '@'
          @_getPending(keyOut).add @_getPending(key)

        for _key of config
          for keyIn in config[_key].in when keyIn.charAt(0) isnt '@'
            if keyIn is key
              @_getPending(_key).add @_getPending(key)

    _exportPendings: ->
      return unless @_hasPending()

      scope = @_getScope()
      config = @_getPendingConfig()

      if config[ @constructor.Defaults.PendingKey ].export
        scope[ 'pending' ] = @pending

      for key of config
        if config[ key ].export
          name = 'pending' + capitalize key
          scope[ name ] = @[ name ]


    _getPending: (key = @constructor.Defaults.PendingKey)->
      return @__pendingStates[ key ]
