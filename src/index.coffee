import formatError from './format-error'
import { extname } from 'path'
import coffee from 'coffeescript'

sourceMap = (out) ->
  if out.v3SourceMap
    JSON.parse out.v3SourceMap
  else
    null

export default (opts = {}) ->
  opts.sourceMap  ?= true
  opts.bare ?= true
  opts.extensions ?= ['.coffee']
  opts.transpile ?= null

  name: 'lry-coffeescript'
  transform: (code, id) ->
    if opts.extensions.indexOf(extname id) is -1
      return null

    try
      out = coffee.compile code,
        filename:  id
        bare: opts.bare
        sourceMap: opts.sourceMap
        transpile: opts.transpile
    catch err
      if err.location?
        err.formattedMessage = formatError code, id, err
      throw err

    code: out.js
    map: sourceMap out
