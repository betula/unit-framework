# @di
di.preRun (config) ->
  config.add
    debug:
      enabled: false
      ns: {}

