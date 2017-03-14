# @di
di.provider 'ComponentReactInputMixin', (MixinAbstract, debug, UnitInitMixin, UnitMixin) ->
  log = debug.ns 'ComponentReactInputMixin'

  class ComponentReactInputMixin extends MixinAbstract

    @dependencies UnitInitMixin

    @input: (values...) ->
      for value in values when value?
        config = {}
        if Array.isArray value
          config[ _value ] = '=' for _value in value
        else if typeof value is 'string'
          config[ value ] = '='
        else if value
          config = value

        Object.defineProperty @, '_input', value: {} unless @hasOwnProperty '_input'
        for own src, dst of config
          @_input[ src ] = dst

    @_getInput: ->
      list = []
      context = @
      while context
        list.push context._input if context._input?
        context = context.prototype.__proto__?.constructor

      config = {}
      for _config in list.reverse()
        for own key, value of _config
          config[ key ] = value

      for own key, value of config when not value?
        delete config[ key ]

      return config

    @constraints: (config = {}) ->
      Object.defineProperty @, '_constraints', value: {} unless @hasOwnProperty '_constraints'
      for own key, rule of config
        @_constraints[ key ] = rule

    @_getConstraints: ->
      list = []
      context = @
      while context
        list.push context._constraints if context._constraints?
        context = context.prototype.__proto__?.constructor

      config = {}
      for _config in list.reverse()
        for own key, value of _config
          config[ key ] = value

      for own key, value of config when not value?
        delete config[ key ]

      return config


    _init: ->
      ComponentReactInputMixin.super @, '_init'

      context = @_getReactContext()
      props = context.props

      constraints = @constructor._getConstraints() or {}

      for name, config of @constructor._getInput()
        config = [ config ] unless Array.isArray config

        method = null
        key = null
        for _config in config
          _config = String _config
          unless (method = _config[ 0 ]) in [ '=' ]
            method = null
            log.warn "Unsupported input method `#{_config[ 0 ]}` for `#{name}` in `#{@constructor.name}` component"
            break
          key = _config[ 1.. ] or name
          if props[ key ]?
            break

        continue unless method

        value = props[ key ]

        pass = true
        if constraints.hasOwnProperty name
          _check = (_value, _rule) ->
            return not value? unless _rule?
            return _rule.hasIn _value if (_rule::) instanceof MixinAbstract or _rule is MixinAbstract
            return _value instanceof _rule if typeof _rule is 'function'
            return typeof _value is _rule if typeof _rule is 'string'

            log.warn "Unsupported constraints for `#{name}` in `#{@constructor.name}` component"
            return false

          rule = constraints[ name ]
          if Array.isArray rule
            pass = false
            for _rule in rule when _check value, _rule
              pass = true
              break
          else
            pass = _check value, rule

        unless pass
          log.warn "Input parameter `#{name}` has unsupported value in `#{@constructor.name}` component"
        else
          setter = 'set' + (name[ ...1 ]).toUpperCase() + name[ 1.. ]
          if typeof @[ setter ] is 'function'
            @[ setter ] value
          else
            @[ name ] = value
            @_bind value if UnitMixin.hasIn value


