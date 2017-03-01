# @di
di.provider 'EventEmitterMixin', (MixinAbstract, debug) ->
  log = debug.ns 'EventEmitterMixin'

  class EventEmitterMixin extends MixinAbstract

    _getListeners: (name) ->
      @__listeners ?= {}
      if name?
        return @__listeners[ name ] ?= []
      else
        return @__listeners

    _removeListeners: ->
      @__listeners = {}

    emit: (name, data...) ->
      names = (name.split /\s+/).filter (value) -> value

      if names.length > 1
        for name in names
          @emit name, data...

      else
        name = names[ 0 ]
        for listener in (@_getListeners name).slice()
          try
            listener? data...
          catch e
            log.error e

    on: (name, fn) ->
      names = (name.split /\s+/).filter (value) -> value

      if names.length > 1
        offs = names.map (name) => @on name, fn

        return ->
          for _off in offs
            _off()
      else
        name = names[ 0 ]
        (@_getListeners name).push fn

        return =>
          @off name, fn

    off: (name, fn) ->
      emitter = this
      names = (name.split /\s+/).filter (value) -> value

      if names.length > 1
        for name in names
          emitter.off name, fn

      else
        name = names[ 0 ]

        listeners = @_getListeners name
        index = 0
        while index < listeners.length
          if listeners[index] is fn
            listeners.splice index, 1
          else
            index++

    once: (name, fn) ->
      _off = @on name, (data...) ->
        fn data...
        _off()
