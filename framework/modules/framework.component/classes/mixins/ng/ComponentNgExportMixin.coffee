# @di
di.provider 'ComponentNgExportMixin', (MixinAbstract, ComponentNgInjectMixin) ->

  class ComponentNgExportMixin extends MixinAbstract

    @dependencies ComponentNgInjectMixin

    @export: (values...) ->
      for value in values when value?
        config = {}
        if Array.isArray value
          config[ _value ] = _value for _value in value
        else if typeof value is 'string'
          config[ value ] = value
        else if value
          config = value

        Object.defineProperty @, '_export', value: {} unless @hasOwnProperty '_export'
        for own src, dst of config
          @_export[ src ] = dst

    @_getExport: ->
      list = []
      context = @
      while context
        list.push context._export if context._export?
        context = context.prototype.__proto__?.constructor

      config = {}
      for _config in list.reverse()
        for own key, value of _config
          config[ key ] = value

      for own key, value of config when not value?
        delete config[ key ]

      return config

    _getExport: ->
      @constructor._getExport()

    _export: (scope) ->
      config = @_getExport()
      context = @

      for to, from of config
        do (to, from) =>
          from = String from
          if (method = from[ 0 ]) in [ '=', '@', '&' ]
            from = from[ 1.. ] or to
          else
            property = @[ from ]
            descriptor = Object.getOwnPropertyDescriptor @, from

            if typeof property is 'function' and ( not descriptor or descriptor.hasOwnProperty 'value' )
              method = '&'
            else
              method = '@'

          switch method
            when '&'
              scope[ to ] = (args...) -> context[ from ] args...
            when '@'
              Object.defineProperty scope, to,
                get: -> context[ from ]
                set: (value) -> context[ from ] = value
            when '='
              scope[ to ] = @[ from ]


    _exportToScope: ->
      @_export @_getScope()

    _afterInit: ->
      ComponentNgExportMixin.super @, '_afterInit'
      @_exportToScope()
