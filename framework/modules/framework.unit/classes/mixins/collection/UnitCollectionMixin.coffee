# @di
di.provider 'UnitCollectionMixin', (MixinAbstract, UnitBindMixin) ->

  class UnitCollectionMixin extends MixinAbstract

    @dependencies UnitBindMixin

    _bindCollectionElement: (element) ->
      @_bind element

    _unBindCollectionElement: (element) ->
      @_unBind element

    clear: ->
      @splice 0, @length

    reset: (values) ->
      @splice 0, @length, values...

    splice: (start, deleteCount, values...) ->
      removed = UnitCollectionMixin.super @, 'splice', start, deleteCount, values...
      @_unBindCollectionElement value for value in removed
      @_bindCollectionElement value for value in values
      return removed

    pop: ->
      return if @length is 0
      @_unBindCollectionElement value = UnitCollectionMixin.super @, 'pop'
      return value

    push: (values...) ->
      UnitCollectionMixin.super @, 'push', values...
      @_bindCollectionElement value for value in values
      return values

    shift: ->
      return if @length is 0
      @_unBindCollectionElement value = UnitCollectionMixin.super @, 'shift'
      return value
      
    unshift: (values...) ->
      UnitCollectionMixin.super @, 'unshift', values...
      @_bindCollectionElement value for value in values
      return values

    toArray: ->
      @slice()
