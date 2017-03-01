# @di
di.provider 'T', (locale, debug) ->
  log = debug.ns 'locale'

  T = (args...) ->
    if typeof args[0] == 'number'
      pluralize args[1], args[0], args.slice(2)...
    else
      translate args...

  T.translate = T.t = translate;
  T.pluralize = T.tn = pluralize;

  translate = (str, args...) ->
    dictionary = locale.dictionary or {}

    if dictionary.hasOwnProperty str
      str = dictionary[str]
    else
      log.info "Undefined \"#{locale.id}\" translation \"#{str}\""
    nextIndex = 0

    next = ->
      if nextIndex >= args.length
        nextIndex = 0
      args[nextIndex++] or ''

    (str or '').replace /(%s)/gi, ->
      next() + ''

  pluralize = (str, n, args...) ->
    dictionary = locale.dictionary or {}
    pluralFn = locale.plural

    n = n or 0
    if !pluralFn
      log.info "Plural function for locale \"#{locale.id}\" is not defined"

      pluralFn = (num) ->
        if num == 1 then 'one' else 'other'

    pluralCase = dictionary[str]

    if !pluralCase or typeof pluralCase != 'object'
      log.info "Plural for string \"#{str}\" for locale \"#{locale.id}\" is not defined"

    else
      pluralCat = pluralFn n

      if !pluralCase.hasOwnProperty pluralCat
        log.info "Plural for category \"#{pluralCat}\" for string \"#{str}\" for locale \"#{locale.id}\" is not defined"
        pluralCat = 'other'

      if pluralCase.hasOwnProperty pluralCat
        str = pluralCase[pluralCat]

    nextIndex = 0

    next = ->
      if nextIndex >= args.length
        nextIndex = 0
      args[nextIndex++] or ''

    (str or '')
    .replace /(%n|\{n})/gi, ->
      n + ''
    .replace /(%s)/gi, ->
      next() + ''

  return T
