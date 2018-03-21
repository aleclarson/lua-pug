:Stack, :add_index, :escape, :noop, :repr = require 'pug.utils'
:merge_attrs = require 'pug.attrs'
:concat = table

-- HTML response
class PugResult
  new: (opts) =>

    unless opts.parent
      @html = {}
      @len = 0

    -- Entry path
    @path = opts.path

    -- File reference resolver
    @resolve = opts.resolve or noop

    -- Template mixins
    @mixins = opts.mixins or {}

    -- Global scope
    @globals = opts.globals or {}

    -- Global metatable
    @global_mt = __index: @globals

    -- Current scope
    @scope = @globals

    -- Dynamic scope
    env = _R: self, _G: @globals
    env._E = env
    @env = setmetatable env,
      __index: (_, k) -> @scope[k]
      __newindex: (_, k, v) -> @scope[k] = v

  -- Append a string.
  push: (value) =>
    if value ~= nil -- nil is ignored
      i = @len + 1
      @html[i] = value
      @len = i

  enter: =>
    @scope = setmetatable {}, __index: @scope

  leave: =>
    @scope = getmetatable(@scope).__index

  -- NOTE: Values are *not* auto-escaped.
  attrs: (attrs, ...) =>
    attrs = merge_attrs attrs, {...}
    for name, val in pairs attrs

      if val == true
        @push ' '
        @push name

      elseif val and val ~= ''
        @push ' '
        @push name
        @push '='
        @push repr val

  call: (id) =>
    setfenv(@funcs[id], @env)!

  mixin: (name, args, ...) =>

    -- Remember the previous scope.
    caller = @scope

    -- Mixins have access to globals and their own scope.
    @scope = setmetatable {}, @global_mt

    -- Set the mixin environment.
    mixin = setfenv @mixins[name], @env

    -- Prepare the `attributes` variable.
    attrs = merge_attrs nil, {...}

    -- Auto-escape any string values.
    for name, val in pairs attrs
      if type(val) == 'string'
        attrs[name] = escape val

    -- Mix it in.
    mixin attrs, unpack args

    -- Reset the scope.
    @scope = caller

  include: (id) =>
    dep = @resolve id, @path
    dep_t = type dep
    if dep_t == 'function'
      dep parent: self
    elseif dep_t == 'string'
      @push dep

return PugResult
