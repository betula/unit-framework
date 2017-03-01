di = DI.module 'framework.component', [
  'framework.common'
  'framework.entity'
  'requires.React'
  'requires.ReactDOM'
]

di.addDecorator 'component', ->
  (component) ->
    component.getReactComponent()
