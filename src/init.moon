PugResult = require 'pug.result'
runtime = require 'pug.runtime'
utils = require 'pug.utils'

return (opts) ->
  local render

  if type(opts.render) == 'function'
    render = opts.render
  if type(opts.template) == 'string'
    render = loadstring(opts.template)!
  elseif type(opts.path) == 'string'
    render = require opts.path
  else
    error "`opts` must have `render`, `template`, or `path`"

  {:concat} = table
  {:add_index} = utils
  {:path, :resolve, :mixins, :globals} = opts

  if globals
    add_index globals, runtime
  else globals = runtime

  return (opts = {}) ->

    if path and not opts.path
      opts.path = path

    if resolve and not opts.resolve
      opts.resolve = resolve

    res = PugResult opts

    -- Provide any shared mixins and globals.
    add_index res.mixins, mixins if mixins
    add_index res.globals, globals

    -- Render the environment.
    setfenv render, res.env
    render res, res.env, res.globals

    -- Return the HTML string.
    concat res.html, ''
