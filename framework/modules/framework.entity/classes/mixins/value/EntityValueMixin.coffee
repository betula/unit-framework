# @di
di.provider 'EntityValueMixin', (MixinAbstract) ->

  class EntityValueMixin extends MixinAbstract

    @prop: (@_prop) ->

    @_getProp: ->
      @_prop or 'value'

    @schema: (schema) ->
      EntityValueMixin.super @, 'schema', "#{@_getProp()}" : schema

    _getProp: ->
      return @__prop ? ( @__prop = @constructor._getProp() )

    _getData: ->
      return ( EntityValueMixin.super @, '_getData' )[ @_getProp() ]

    _setData: (value) ->
      if arguments.length is 0
        EntityValueMixin.super @, '_setData'
      else
        EntityValueMixin.super @, '_setData', "#{@_getProp()}" : value

    getValue: ->
      return @[ @_getProp() ]

    setValue: (value) ->
      @setData value
