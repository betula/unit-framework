# @di
di.provider 'DateEntityValue', (EntityValueAbstract) ->

  class DateEntityValue extends EntityValueAbstract

    @schema Date
