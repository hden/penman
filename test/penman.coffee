'use strict'

stream   = require 'stream'
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

    transformer = (s) ->
      s + '!!'

    app
    .map('column1', 'foo', undefined)
    .map('column2', 'bar', 'default value', transformer)
    .map('column3', 'baz.deep.path', 'default value')

  it 'should export the parser', ->
    assert.isFunction app

  it 'should map path', ->
    result = app target
    assert.equal result, 'fooValue,bar!!,wow\n'

  it 'should provide a streaming interface', (done) ->
    transformingStream = app.stream()
    assert.instanceOf transformingStream, stream.Transform
    assert.isFunction transformingStream._transform
    transformingStream.on 'data', (chunk, enc = 'utf-8', cb) ->
      assert.instanceOf chunk, Buffer
      result = do chunk.toString
      assert.equal result, 'fooValue,bar!!,wow\n'
      do done

    transformingStream.write target
