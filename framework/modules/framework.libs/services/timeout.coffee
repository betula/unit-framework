# @di
di.provider 'timeout', (Q, window) ->

  deferreds = {}

  timeout = (fn, delay) ->
    if typeof fn isnt 'function'
      delay = fn
      fn = ->

    deferred = Q.defer()
    timeoutId = window.setTimeout ( ->
      try
        deferred.resolve fn()
      catch e
        deferred.reject e
    ), delay

    promise = deferred.promise

    promise.__timeoutId = timeoutId
    deferreds[ timeoutId ] = deferred

    return promise

  timeout.cancel = (promise) ->
    if promise and ( timeoutId = promise.__timeoutId ) of deferreds
      deferreds[ timeoutId ].promise.catch ->
      deferreds[ timeoutId ].reject 'canceled'
      delete deferreds[ timeoutId ]

  return timeout
