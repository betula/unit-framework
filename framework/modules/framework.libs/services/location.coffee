# @di
di.provider 'location', (history, window, QS) ->

  browserLocation = window.location

  new class Location

    port: ->
      browserLocation.port

    protocol: ->
      browserLocation.protocol

    host: ->
      browserLocation.host
      
    search: (name, value) ->
      if typeof value isnt 'undefined'
        query = QS.parse browserLocation.search
        query[ name ] = value
        delete query[ name ] unless value?

      else
        query = name

      if typeof query is 'string'
        throw new Error 'Query string unsupported'

      unless query?
        return QS.parse browserLocation.search

      historyLocation = history.createLocation browserLocation
      historyLocation.query = query
      history.push historyLocation

      return historyLocation.query

    hash: (value) ->
      if value
        browserLocation.hash = value

      hash = browserLocation.hash
      hash = hash.slice 1 if hash[ 0 ] is '#'

      return hash

    url: (value, query) ->
      unless value?
        unless query?
          return history.createHref browserLocation
        else
          historyLocation = history.createLocation browserLocation
          historyLocation.query = query
          history.push historyLocation

          return history.createHref historyLocation

      else
        historyLocation = history.createLocation value
        historyLocation.query = query if query?
        history.push historyLocation

        return history.createHref historyLocation

    path: (value) ->
      unless value?
        return browserLocation.pathname

      historyLocation = history.createLocation browserLocation
      historyLocation.pathname = value
      history.push historyLocation

      return historyLocation.pathname
