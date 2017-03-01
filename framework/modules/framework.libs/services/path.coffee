# @di
di.provider 'path', ->

  new class Path

    join: (pieces...) ->
      if !pieces.length
        return ''

      return pieces
      .map (piece) ->
        return (String piece or '').trim()
      .reduce (left, right) ->
        index = left.length - 1
        counter = 0

        while index >= 0 and left[index] == '/'
          counter++
          index--

        while counter > 0 and right.length > 0 and right[0] == '/'
          right = right.slice(1)
          counter--

        if left and right and left[left.length - 1] != '/' and right[0] != '/'
          left += '/'

        return left + right
