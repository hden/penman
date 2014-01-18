'use strict'

{assert} = require 'chai'

describe 'penman', ->

  app    = undefined
  target =
    foo: 'fooValue'
    bar: 'bar'
    baz:
      deep:
        path: 'wow'

  before ->
    app = require "#{__dirname}/../"

  it 'should export the parser', ->
    assert.isFunction app

  it 'should map path', ->
    transformer = (s) ->
      s + '!!'

    app
    .map('column1', 'foo', undefined)
    .map('column2', 'bar', 'default value', transformer)
    .map('column3', 'baz.deep.path', 'default value')

    result = app target
    assert.equal result, 'fooValue,bar!!,wow'
