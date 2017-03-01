# @di
di.provider 'dateFormatter', (moment) ->
  (date, format, timezone) ->
    date = new Date() unless date
    date = new Date date if date not instanceof Date or timezone?
    return null if String( date ) is 'Invalid Date'

    if timezone?
      timezone = String timezone
      switch timezone[ 0 ]
        when '-'
          inverseTimezone = '+' + timezone[ 1 .. ]
        when '+'
          inverseTimezone = '-' + timezone[ 1 .. ]
        else
          inverseTimezone = '-' + timezone

      date.setMinutes( date.getMinutes() + date.getTimezoneOffset() )
      date = new Date( date.toISOString().slice(0, -1) + inverseTimezone )

    return moment( date ).format( format )
