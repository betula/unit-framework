# @di
di.provider 'UnitCollectionApplyMixin', (MixinAbstract, UnitApplyMixin, UnitCollectionMixin) ->

  class UnitCollectionApplyMixin extends MixinAbstract

    @dependencies UnitApplyMixin, UnitCollectionMixin

    clear: ->
      result = UnitCollectionApplyMixin.super @, 'clear'
      @apply()
      return result

    splice: (args...) ->
      result = UnitCollectionApplyMixin.super @, 'splice', args...
      @apply()
      return result

    pop: ->
      result = UnitCollectionApplyMixin.super @, 'pop'
      @apply()
      return result

    push: (args...) ->
      result = UnitCollectionApplyMixin.super @, 'push', args...
      @apply()
      return result

    shift: ->
      result = UnitCollectionApplyMixin.super @, 'shift'
      @apply()
      return result

    unshift: (args...) ->
      result = UnitCollectionApplyMixin.super @, 'unshift', args...
      @apply()
      return result

    sort: (args...) ->
      result = UnitCollectionApplyMixin.super @, 'sort', args...
      @apply()
      return result
