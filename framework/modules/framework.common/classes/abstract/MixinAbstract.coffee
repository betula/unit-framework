# @di
di.provider 'MixinAbstract', (MixableAbstract, MixableCollectionAbstract, debug, unique, ObjectAbstract) ->
  log = debug.ns 'MixinAbstract'

  class MixinAbstract extends ObjectAbstract

    @property: (name, descriptor) ->
      descriptor.enumerable = true if descriptor and not descriptor.enumerable?
      super name, descriptor

    @hasIn: (object) ->
      return unless object instanceof MixableAbstract or object instanceof MixableCollectionAbstract

      Object.defineProperty object, '__mixins', value: {} unless object.hasOwnProperty '__mixins'
      mixins = object.__mixins
      id = @_id()
      unless mixins.hasOwnProperty id
        mixins[ id ] = object.constructor._hasMixin @
      return mixins[ id ]

    @hasInClass: (object) ->
      if object is MixableAbstract or (object::) instanceof MixableAbstract or object is MixableCollectionAbstract or (object::) instanceof MixableCollectionAbstract
        object._hasMixin this
      else
        false

    @dependencies: (args...) ->
      Object.defineProperty @, '_dependencies', value: [] unless @hasOwnProperty '_dependencies'
      @_dependencies.push args...

    @_getDependencies: ->
      result = []
      context = this
      while context
        result.push context._dependencies... if Array.isArray context._dependencies
        context = context.prototype.__proto__?.constructor
      return result

    @invoke: (args...) ->
      Object.defineProperty @, '_invokes', value: [] unless @hasOwnProperty '_invokes'
      @_invokes.push args...

    @_getInvokes: ->
      result = []
      context = this
      while context
        result.unshift context._invokes if Array.isArray context._invokes
        context = context.prototype.__proto__?.constructor
      return [].concat result...

    @_id: ->
      unless @hasOwnProperty '__id'
        Object.defineProperty @, '__id', value: @name + '_' + unique()
      return @__id

    @_getTree: ->
      tree = []
      mixin = this
      while mixin and mixin isnt MixinAbstract
        tree.unshift mixin
        mixin = mixin.prototype.__proto__?.constructor
      return tree

    @super: (object, method, args...) ->

      find = (context) =>
        id = @_id()
        found = false
        _context = context
        while _context
          if _context._mixins
            found = _context._mixins.hasOwnProperty id
            break if found
          _context = _context.prototype.__proto__?.constructor

        unless found
          msg = "Mixin #{@name} not found in #{context.name}"
          log.error msg
          throw new Error msg

        return _context

      mixins = (context) =>
        list = []
        for id, mixin of context._mixins
          break if mixin is @
          list.push mixin
        return list.reverse()

      if typeof object is 'function'

        context = find object
        for mixin in (mixins context) when `method in mixin`
          return mixin[ method ].apply object, args

        return context.__super__.constructor[ method ].apply object, args

      else if object instanceof MixableAbstract or object instanceof MixableCollectionAbstract

        context = find object.constructor
        for mixin in (mixins context) when `method in mixin`::
          return mixin::[ method ].apply object, args

        return context.__super__[ method ].apply object, args

      else
        msg = "Unsupported context for mixin #{@name} super call"
        log.error msg
        throw new Error msg
