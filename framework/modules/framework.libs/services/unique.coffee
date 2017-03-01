# @di
di.provider 'unique', ->
  return ->
    ( Math.random().toString 36 ).slice 2
