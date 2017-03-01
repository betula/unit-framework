# @di
di.provider 'http', (request, lodash, Q) ->

  (config) ->
    config = lodash.clone config
    config.body ?= config.data
    config.qs ?= config.params
    config.json ?= true

    Q (resolve, reject) ->
      request config, (error, xhr) ->
        response =
          data: xhr.body
          status: xhr.status

        if error
          reject response
        else
          resolve response
