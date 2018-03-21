PugResult = require 'pug.result'
runtime = require 'pug.runtime'
utils = require 'pug.utils'

return (opts) ->
  local render, mixins

  if type(opts.render) == 'function'
    :render, :mixins = opts
  elseif type(opts.template) == 'string'
    loader = loadstring opts.template
    render, mixins = setfenv(loader, {})!
  else
    error "`opts` must have `render` or `template`"

  :concat = table
  :add_index = utils
  :path, :resolve, :globals = opts

  if globals
    add_index globals, runtime
  else globals = runtime

  return (opts = {}) ->
    :parent = opts

    unless opts.resolve
      if resolve
        opts.resolve = resolve
      elseif parent
        opts.resolve = parent.resolve

    opts.path = path
    res = PugResult opts

    -- Push directly to the parent.
    if parent then res.push = (str) => parent\push str

    -- Expose bound mixins.
    add_index res.mixins, mixins if mixins

    -- Expose parent globals or bound globals (never both).
    add_index res.globals, parent and parent.globals or globals

    -- Render the environment.
    setfenv(render, res.env)!

    -- Return the HTML string.
    concat res.html, '' unless parent
