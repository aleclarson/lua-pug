PugResult = require 'pug.result'
runtime = require 'pug.runtime'
utils = require 'pug.utils'

return (opts) ->
  local render, mixins

  if type(opts.render) == 'function'
    :render, :mixins = opts
  elseif type(opts.template) == 'string'
    loader = loadstring opts.template
    :render, :mixins = setfenv(loader, {})!
  else
    error "`opts` must have `render` or `template`"

  {:concat} = table
  {:add_index} = utils
  {:path, :resolve, :globals} = opts

  if globals
    add_index globals, runtime
  else globals = runtime

  return (opts = {}) ->

    if resolve and not opts.resolve
      opts.resolve = resolve

    opts.path = path
    res = PugResult opts

    -- Provide any shared mixins and globals.
    add_index res.mixins, mixins if mixins
    add_index res.globals, globals

    -- Render the environment.
    setfenv(render, res.env)!

    -- Return the HTML string.
    concat res.html, ''
