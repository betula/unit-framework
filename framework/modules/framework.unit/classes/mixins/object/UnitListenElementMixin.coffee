# @di
di.provider 'UnitListenElementMixin', (MixinAbstract, UnitListenMixin, jq, window) ->

  # @see https://github.com/angular/angular.js/blob/v1.5.6/src/Angular.js#L708
  isElement = (node) ->
    !!( node and
      ( node.nodeName or # We are a direct element.
        ( node.prop and # We have an on and find method part of jQuery API.
          node.attr and
          node.find)))

  class UnitListenElementMixin extends MixinAbstract

    @dependencies UnitListenMixin

    _listen: (args...) ->
      [element] = args
      if element isnt window and not isElement element
        return UnitListenElementMixin.super @, '_listen', args...
      else
        element = jq element
        [_, event, listener, context = @] = args
        _listener = listener.bind context
        element.bind event, _listener

        _releaseDelegate = ->
          element.unbind event, _listener

        @_addReleaseDelegate _releaseDelegate

        return _releaseDelegate
