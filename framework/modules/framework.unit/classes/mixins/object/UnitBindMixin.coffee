# @di
di.provider 'UnitBindMixin', (MixinAbstract, MixedMap) ->

  class UnitBindMixin extends MixinAbstract

    _bindUnit: (unit) ->
      map = (@__bindedUnitMap ?= new MixedMap)
      counter = (map.get unit) or 0
      map.set unit, counter + 1
      if counter is 0
        @_addUnitBinding unit

    _unBindUnit: (unit) ->
      map = @__bindedUnitMap
      counter = map.get unit
      if counter is 1
        map.delete unit
        @_releaseUnitBinding unit
      else
        map.set unit, counter - 1

    _addUnitBinding: (unit) ->
      unit._incBindCounter()

    _releaseUnitBinding: (unit) ->
      unit._decBindCounter()

    _getBindCounter: ->
      return @__bindCounter ? 0

    _incBindCounter: ->
      @__bindCounter = (@__bindCounter ? 0) + 1

    _decBindCounter: ->
      @__bindCounter -= 1

    _bind: (unit) ->
      if UnitBindMixin.hasIn unit
        @_bindUnit unit
      return unit

    _unBind: (unit) ->
      if UnitBindMixin.hasIn unit
        @_unBindUnit unit
      return unit

    getBindCounter: ->
      @_getBindCounter()
