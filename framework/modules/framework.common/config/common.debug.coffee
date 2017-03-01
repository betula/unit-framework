# @di
di.preRun (config) ->
  config.add debug:
    enabled: true
    warn: true
    error: true

