# @di
di.provider 'BooleanEntityValue', (EntityValueAbstract) ->

  class BooleanEntityValue extends EntityValueAbstract

    @schema Boolean
