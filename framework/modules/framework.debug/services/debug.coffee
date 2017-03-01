# @di
di.provider 'debug', (config) ->
  pool = {}

  Debug = (ns) ->
    _debug = (args...) ->
      _debug.log args...

    Object.defineProperty _debug, 'enabled',
      get: ->
        @_enabled and debug._enabled
      set: (enabled) ->
        @_enabled = enabled

      enumerable: true
      configurable: true

    _debug._enabled = false
    _debug._warn = debug?._warn ? false
    _debug._error = debug?._error ? false

    for name in [ 'log', 'info', 'error', 'warn' ]
      do (name) ->
        _debug[ name ] = (args...) ->
          if ( @_enabled and debug._enabled ) or ( name is 'error' and @_error and debug._error ) or ( name is 'warn' and @_warn and debug._warn )

            args.unshift "%c#{ns}:", 'font-weight: bold' if ns
            console[ name ] args...

    return _debug

  debug = new Debug

  debug.ns = (ns) ->
    return this unless ns
    return pool[ ns ] if pool.hasOwnProperty ns
    pool[ ns ] = new Debug ns

  _config = config.debug

  if typeof _config is 'boolean'
    debug._enabled = _config
    debug._warn = _config
    debug._error = _config

  else
    debug._enabled = _config?.enabled ? false
    debug._warn = _config?.warn ? false
    debug._error = _config?.error ? false

  for own ns, cfg of _config?.ns or {}
    if typeof cfg is 'boolean'
      debug.ns( ns )._enabled = cfg
      debug.ns( ns )._warn = cfg
      debug.ns( ns )._error = cfg

    else
      debug.ns( ns )._enabled = cfg.enabled if cfg?.enabled?
      debug.ns( ns )._warn = cfg.warn if cfg?.warn?
      debug.ns( ns )._error = cfg.error if cfg?.error?

  return debug


