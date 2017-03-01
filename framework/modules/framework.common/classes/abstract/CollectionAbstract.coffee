# @di
di.provider 'CollectionAbstract', ->

  class CollectionAbstract extends Array

    @property: (name, descriptor) ->
      Object.defineProperty @::, name, descriptor

    constructor: (data...) ->
      super()

      values = []
      for value in data
        if value instanceof Array
          values.push value.slice()...
        else
          values.push value

      @push values...
