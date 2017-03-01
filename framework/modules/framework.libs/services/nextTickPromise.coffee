# @di
di.provider 'nextTickPromise', (nextTick, Q) ->
  ->
    return Q (resolve) ->
      nextTick resolve
