# @di
di.provider 'ComponentInputMixin', (MixinAbstract, debug, ComponentInjectMixin, UnitInitMixin, UnitApplyMixin, ComponentDirectiveMixin, UnitMixin) ->
  log = debug.ns 'ComponentInputMixin'

  class ComponentInputMixin extends MixinAbstract

    @dependencies ComponentInjectMixin, UnitInitMixin, UnitApplyMixin, ComponentDirectiveMixin

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
      ComponentInputMixin.super @, '_init'

      scope = @_getScope()
      attrs = @_getAttrs()

      constraints = @constructor._getConstraints() or {}

      for name, config of @constructor._getInput()
        config = [ config ] unless Array.isArray config

        method = null
        key = null
        for _config in config
          _config = String _config
          unless (method = _config[ 0 ]) in [ '=', '@', '&' ]
            method = null
            log.warn "Unsupported input method `#{_config[ 0 ]}` for `#{name}` in `#{@constructor.name}` component"
            break
          key = _config[ 1.. ] or name
          if attrs[ key ]?
            break

        continue unless method

        switch method
          when '='
            value = null
            if @constructor._scope or typeof @constructor._scope is 'undefined'
              value = scope.$parent.$eval attrs[ key ] if attrs[ key ]
            else
              value = scope.$eval attrs[ key ] if attrs[ key ]
          when '@'
            value = attrs[ key ]
          when '&'
            value = ->
            if attrs[ key ]
              expr = attrs[ key ]

              do (expr) =>
                if @constructor._scope or typeof @constructor._scope is 'undefined'
                    value = (locals) ->
                      scope.$parent.$eval expr, locals
                else
                  value = (locals) ->
                    scope.$eval expr, locals



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


