# @di
di.provider 'config', (lodash) ->

  class Config

    add: (object) ->
      lodash.merge @, object

  return new Config
