# @di
di.provider 'MixableAbstract', (debug, ObjectAbstract) ->
  log = debug.ns 'MixableAbstract'

  instanceKeywords = [
    'constructor'
  ]
  classKeywords = [
    '__super__'
    'property'
    'super'
    '_id'
    '_getTree'
    'hasInClass'
    'hasIn'
    'dependencies'
    '_getDependencies'
    'invoke'
    '_getInvokes'
  ]

  class MixableAbstract extends ObjectAbstract

    @mixins: (mixins...) ->
      for mixin in [].concat mixins...
        tree = mixin._getTree()
        id = mixin._id()
        invokes = mixin._getInvokes()
        if @_hasAnyMixin tree
          log.warn "One or more mixins from #{tree.map (mixin) -> mixin.name} already exists in #{mixin.name}"
          continue
        else
          unless @_hasAllMixins (dependencies = mixin._getDependencies())
            msg = "Mixin #{mixin.name} has unresolved dependencies one or more of #{dependencies.map (mixin) -> mixin.name}"
            log.error msg
            throw new Error msg

          fn.call @ for fn in invokes when typeof fn is 'function'

          for key in Object.keys mixin::
            unless key in instanceKeywords
              Object.defineProperty @::, key, Object.getOwnPropertyDescriptor mixin::, key

          for key, property of mixin
            unless key in classKeywords
              @[ key ] = property

          Object.defineProperty @, '_mixins', value: {} unless @hasOwnProperty '_mixins'
          @_mixins[ id ] = mixin for mixin in tree

    @_hasAnyMixin: (list) ->
      context = @
      while context
        if context._mixins
          for mixin in list when context._mixins.hasOwnProperty mixin._id()
            return true
        context = context.prototype.__proto__?.constructor

    @_hasAllMixins: (list) ->
      list = list.slice()
      context = @
      while context and list.length isnt 0
        if context._mixins
          for index in [list.length - 1 .. 0] when context._mixins.hasOwnProperty list[ index ]._id()
            list.splice index, 1
        context = context.prototype.__proto__?.constructor
      return list.length is 0

    @_hasMixin: (mixin) ->
      found = false
      context = @
      while context and not found
        found = context._mixins.hasOwnProperty mixin._id() if context._mixins
        context = context.prototype.__proto__?.constructor

      return found
