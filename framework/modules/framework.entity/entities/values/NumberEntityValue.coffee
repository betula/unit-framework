# @di
di.provider 'NumberEntityValue', (EntityValueAbstract) ->

  class NumberEntityValue extends EntityValueAbstract

    @schema Number
