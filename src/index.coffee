'use strict'

stream       = require 'stream'
getPathValue = require 'chai/lib/chai/utils/getPathValue'

class Transform extends stream.Transform
  constructor: ->
    super
    @_writableState.objectMode = true
    @_readableState.objectMode = false

penman = (obj = {}) ->
  row = penman.queue.map ({key, path, defaults, transform}) ->
    value = getPathValue(path, obj) or defaults
    value = transform value if transform?
    value
  row.join penman._delimiter

penman.getPathValue = getPathValue
penman._delimiter   = ','
penman.queue        = []

penman.map = (key = '', path = '', defaults = '', transform) ->
  penman.queue.push {key, path, defaults, transform}
  penman

penman.delimiter = (delimiter) ->
  if delimiter?
    penman._delimiter = delimiter
    penman
  else
    penman._delimiter

penman.stream = (options) ->
  s = new Transform(options)
  s._transform = (chunk = {}, enc, done) ->
    s.push penman chunk
    do done
  s

module.exports = penman
