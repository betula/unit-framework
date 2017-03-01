# @di
di.provider 'nextTick', (window) ->
  (fn) ->
    window.setTimeout fn
