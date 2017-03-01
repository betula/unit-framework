# @di
di.provider 'StringEntityValue', (EntityValueAbstract) ->

  class StringEntityValue extends EntityValueAbstract

    @schema String
