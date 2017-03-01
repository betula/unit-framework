# @di
di.provider 'Q', [ 'promise' ], (Promise) ->
  Q = (fn) -> new Promise fn

  for prop in [ 'all', 'resolve', 'reject' ]
    Q[ prop ] = Promise[ prop ]

  Q.hash = (hash) ->
    keys = Object.keys hash
    promises = keys.map (key) -> hash[ key ]

    Promise.all( promises ).then (values) ->
      result = {}
      for key, i in keys
        result[ key ] = values[ i ]
      return result

  Q.defer = ->
    resolve = reject = null
    promise = new Promise (_resolve, _reject) ->
      resolve = _resolve
      reject = _reject

    return { resolve, reject, promise }

  return Q
