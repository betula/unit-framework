((window) ->

  class DependencyInjection

    constructor: ->
      @_modules = {}

    _getModules: (names = []) ->
      result = []
      for name in names
        unless @_modules.hasOwnProperty name
          throw new Error "Module \"#{name}\" not defined"
        else
          result.push @_modules[ name ]
      return result

    create: (name, dependencies = []) ->
      if @_modules.hasOwnProperty name
        throw new Error "Module \"#{name}\" already exists"
      else
        @_modules[ name ] = new DependencyInjectionModule name, @_getModules( dependencies ) #, @_decorators

      return @_modules[ name ]

    module: (args...) ->
      @create args...

    get: (name) ->
      @_getModules( [ name ] )[ 0 ]


  class DependencyInjectionModule

    constructor: (@_name, @_dependencies = []) ->
      @_decorators = {}
      @_providers = {}
      @_preRunPhaseDelegates = []
      @_runPhaseDelegates = []

      @_addDecorators module._getDecorators() for module in @_dependencies

    _getName: ->
      return @_name

    _getDependencies: ->
      return @_dependencies

    _getProviders: ->
      return @_providers

    _getDecorators: ->
      return @_decorators

    _getPreRunPhaseDelegates: ->
      return @_preRunPhaseDelegates

    _getRunPhaseDelegates: ->
      return @_runPhaseDelegates

    _addDecorators: (decorators) ->
      @_addDecorator name, decorator for name, decorator of decorators

    _addDecorator: (name, decorator) ->
      @_decorators[ name ] = decorator
      @[ name ] = (name, args...) ->
        provider = @_resolveProvider args...
        @_providers[ name ] = (injector) -> decorator( injector ) provider( injector )

    _addProvider: (name, provider) ->
      @_providers[ name ] = provider

    _resolveProvider: (provider, fn) ->
      if typeof provider is 'function'
        unless provider.$inject?.length > 0
          return provider
        else
          provider = [ provider.$inject..., provider ]

      unless provider instanceof Array
        throw new Error "Provider format incorrect"

      if typeof fn is 'function'
        provider = [].concat provider, fn

      [ dependencies..., fn ] = provider
      return (injector) ->
        return fn ( injector.get name for name in dependencies )...

    provider: (name, args...) ->
      @_addProvider name, @_resolveProvider args...

    decorator: (name, args...) ->
      @_addDecorator name, @_resolveProvider args...

    run: (args...) ->
      @_runPhaseDelegates.push @_resolveProvider args...

    preRun: (args...) ->
      @_preRunPhaseDelegates.push @_resolveProvider args...

    start: ->
      new DependencyInjectionInjector( @ ).run()


  class DependencyInjectionInjector

    constructor: (module) ->
      @_name = module._getName()
      @_instances = {}

      @_extractModuleProviders module

      @_instances[ 'injector' ] = @

    _extractModuleProviders: (module) ->

      providers = {}
      preRunPhaseDelegates = []
      runPhaseDelegates = []

      performed = {}

      walk = (module) ->
        walk dependency for dependency in module._getDependencies()

        unless performed[ moduleName = module._getName() ]
          performed[ moduleName ] = true

          for providerName, provider of module._getProviders()
            providers[ providerName ] = provider

          preRunPhaseDelegates.push module._getPreRunPhaseDelegates()...
          runPhaseDelegates.push module._getRunPhaseDelegates()...

      walk module

      @_providers = providers
      @_preRunPhaseDelegates = preRunPhaseDelegates
      @_runPhaseDelegates = runPhaseDelegates

    _preRunPhaseStart: ->
      fn( @ ) for fn in @_preRunPhaseDelegates

    _runPhaseStart: ->
      fn( @ ) for fn in @_runPhaseDelegates

    run: ->
      @_preRunPhaseStart()
      @_runPhaseStart()

    get: (name) ->
      return @_instances[ name ] if @_instances.hasOwnProperty name
      return @_instances[ name ] = @_providers[ name ]( @ ) if @_providers.hasOwnProperty name

      throw new Error "Provider \"#{name}\" not defined in module \"#{@_name}\""



  window.DI = new DependencyInjection

)( window )
