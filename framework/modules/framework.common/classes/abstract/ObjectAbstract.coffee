# @di
di.provider 'ObjectAbstract', ->

  class ObjectAbstract

    @property: (name, descriptor) ->
      Object.defineProperty @::, name, descriptor
