# @di
di.preRun (config) ->

  PLURAL_CATEGORY =
    ZERO: 'zero'
    ONE: 'one'
    TWO: 'two'
    FEW: 'few'
    MANY: 'many'
    OTHER: 'other'

  getDecimals = (n) ->
    n = n + ''
    i = n.indexOf '.'
    if i is -1 then 0 else n.length - i - 1

  getVF = (n, opt_precision) ->
    v = opt_precision
    v = Math.min( getDecimals(n), 3 ) unless v?
    base = 10 ** v
    f = ( n * base | 0 ) % base
    return { v, f }

  # @see https://github.com/angular/bower-angular-i18n/blob/v1.5.6/angular-locale_en-gb.js#L141
  pluralEn = (n, opt_precision) ->
    i = n | 0
    vf = getVF(n, opt_precision)
    if i is 1 and vf.v is 0
      return PLURAL_CATEGORY.ONE
    PLURAL_CATEGORY.OTHER

  # @see https://github.com/angular/bower-angular-i18n/blob/v1.5.6/angular-locale_ru.js
  pluralRu = (n, opt_precision) ->
    i = n | 0
    vf = getVF(n, opt_precision)
    if vf.v is 0 and i % 10 is 1 and i % 100 isnt 11
      return PLURAL_CATEGORY.ONE
    if vf.v is 0 and i % 10 >= 2 and i % 10 <= 4 and (i % 100 < 12 or i % 100 > 14)
      return PLURAL_CATEGORY.FEW
    if vf.v is 0 and i % 10 is 0 or vf.v is 0 and i % 10 >= 5 and i % 10 <= 9 or vf.v is 0 and i % 100 >= 11 and i % 100 <= 14
      return PLURAL_CATEGORY.MANY
    PLURAL_CATEGORY.OTHER

  config.add
    locale:
      plurals:
        en: pluralEn
        ru: pluralRu
