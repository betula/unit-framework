# @di
di.provider 'priorityScheduler', (Q, debug, EventEmitter) ->
  log = debug.ns 'priorityScheduler'
  uid = ->
    uid._counter ?= 0
    uid._counter++
    return uid._counter.toString 16


  class SwitchCounter extends EventEmitter

    constructor: ->
      super()
      @_count = 0

    inc: ->
      if not @_count then @emit 'begin'
      @_count++

    dec: ->
      if !@_count then return
      @_count--
      if not @_count then @emit 'end'

    has: ->
      @_count > 0

    clear: ->
      count = @_count
      @_count = 0
      if count then @emit 'end'


  class ActivityWatcher extends SwitchCounter

    constructor: (values...) ->
      super()
      @add values...

    add: (values...) ->
      if not values.length then return

      list = values.map (value) =>
        if value instanceof ActivityWatcher
          if value.has() then @inc()
          removeStartListener = value.on 'begin', => @inc()
          removeStopListener = value.on 'end', => @dec()

          return ->
            removeStartListener()
            removeStopListener();
            if value.has() then @dec()

        canceled = false
        silent = true
        resolved = false
        Q.resolve value
        .finally =>
          resolved = true
          if not silent and not canceled then @dec()
        silent = false

        if not resolved then @inc()

        return =>
          canceled = true
          if not resolved then @dec()

      return ->
        list.forEach (fn) -> fn()

    getInactivityPromise: ->
      if not @_count then return Q.resolve()

      deferred = Q.defer()
      @once 'end', -> deferred.resolve()

      return deferred.promise


  class PriorityRunner

    class Item
      constructor: (@priority, self, high = null) ->
        @high = new ActivityWatcher high
        @self = new ActivityWatcher self, @high

    constructor: ->
      @_collection = []
      @_map = {}

    run: (priority, promise) ->
      if @_map.hasOwnProperty priority
        item = @_map[ priority ]
        item.self.add promise

      else
        item = new Item priority, promise

        created = false
        for index in [0 ... @_collection.length]
          if priority > @_collection[ index ].priority
            @_collection.splice index, 0, item
            created = true
            break
        if !created
          @_collection.push item
          created = true

        @_map[ priority ] = item

        for index in [@_collection.length - 1 .. 0]
          if @_collection[ index ] == item
            break
          @_collection[ index ].high.add item.self

        item.high.add (@_collection[ i ].self for i in [0 ... index])...

      return item.high.getInactivityPromise()


  class Scheduler

    @Priority:
      High: 100
      Normal: 50
      Low: 10

    constructor: () ->
      @_runner = new PriorityRunner()

    task: (priority, fn) ->
      if typeof priority == 'function'
        fn = priority
        priority = Scheduler.Priority.Normal

      id = uid()
      log "Task (#{id}) priority #{priority} register"

      deferred = Q.defer()

      if debug.enabled
        deferred.promise.then \
        => log "Task (#{id}) priority #{priority} ok",
        => log "Task (#{id}) priority #{priority} cancel"

      finish = (value) -> deferred.resolve value

      canceled = false
      cancel = (value) ->
        canceled = true
        deferred.reject value

      promise = @_runner.run priority, deferred.promise
      .then ->
        if canceled
          return deferred.promise

      isPromise = (value) ->
        return value and typeof value.then == 'function' and typeof value.catch == 'function'

      if fn
        promise = promise.then ->
          value = fn finish, cancel
          if isPromise value
            value.then finish, cancel
          return deferred.promise
      else
        _then = promise.then
        promise.then = (fn) ->
          return _then.call promise, ->
            value = fn and fn()
            if isPromise value
              value.then finish, cancel
            else
              finish value
            return deferred.promise

      promise.finish = finish
      promise.cancel = cancel

      return promise

    high: (fn) ->
      return @task Scheduler.Priority.High, fn

    normal: (fn) ->
      return @task Scheduler.Priority.Normal, fn

    low: (fn) ->
      return @task Scheduler.Priority.Low, fn


  return new Scheduler
