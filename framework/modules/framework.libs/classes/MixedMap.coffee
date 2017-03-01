# @di
di.provider 'MixedMap', (window) ->

  if typeof window.Map is 'function'

    # For modern browsers
    class MixedMap

      constructor: ->
        @_map = new Map()

      get: (key) ->
        return @_map.get key

      has: (key) ->
        return @_map.has key

      set: (key, value) ->
        @_map.set key, value
        return @

      clear: ->
        @_map.clear()
        return @

      keys: ->
        iterator = @_map.keys()
        return (value.value until ( value = iterator.next() )?.done)

      values: ->
        iterator = @_map.values()
        return (value.value until ( value = iterator.next() )?.done)

      delete: (key) ->
        return @_map.delete key

  else

    class MixedMap

      constructor: ->
        @_index = []
        @_list = []

      get: (key) ->
        if (index = @_index.indexOf key) isnt -1
          return @_list[ index ]
        return

      has: (key) ->
        return (@_index.indexOf key) isnt -1

      set: (key, value) ->
        if (index = @_index.indexOf key) is -1
          index = (@_index.push key) - 1
        @_list[ index ] = value
        return @

      clear: ->
        @_index.length = 0
        @_list.length = 0

      keys: ->
        return @_index.slice()

      values: ->
        return @_list.slice()

      delete: (key) ->
        if (index = @_index.indexOf key) is -1
          return false

        @_index.splice index, 1
        @_list.splice index, 1
        return true


