# @di
di.provider 'UnitCollection', (UnitCollectionAbstract) ->

  class UnitCollection extends UnitCollectionAbstract

    _init: (args...) ->
      @push ( [].concat args... )...
      super args...
