
Stack = do
  __len: => @len
  __index:
    get: (i) => self[i or @len]
    push: (val) =>
      @len = @len + 1
      self[@len] = val
    pop: =>
      self[@len] = nil
      @len = @len - 1

setmetatable Stack,
  __call: -> setmetatable {len: 0}, Stack

join_index = (mt, b) ->
  a = mt.__index

  if type(a) == 'table'
    mt.__index = (k) =>
      x = a[k]
      x = b[k] if x == nil
      x

  elseif type(a) == 'function'
    mt.__index = (k) =>
      x = a(k)
      x = b[k] if x == nil
      x

  else mt.__index = b

add_index = (a, b) ->
  mt = getmetatable a
  if mt == nil
    setmetatable a, __index: b
  elseif mt.__index == nil
    mt.__index = b
  else
    join_index mt, b

assign = (dest, src) ->
  for key, value in pairs src
    dest[key] = value

coercable = (val) ->
  mt = getmetatable val
  mt and mt.__tostring ~= nil

escaped_chars =
  '&': '&amp;'
  '<': '&lt;'
  '>': '&gt;'
  '"': '&quot;'
  "'": '&#39;'

escape = (val) ->
  val\gsub '[&<>"\']', escaped_chars

get_keys = (tbl) ->
  keys, i = {}, 1
  for key in pairs tbl
    keys[i], i = key, i + 1
  keys

noop = ->

-- Lua equivalent of Python `repr`
repr = (str) -> ('%q')\format(str)\gsub '\\\n', '\\n'

stringify = (val) ->
  -- "nil" is ignored.
  if val ~= nil
    val_t = type val
    return val if val_t == 'string'
    -- "cdata" and "userdata" are ignored.
    return if val_t\match 'data$'
    -- Coerce non-strings if possible.
    if val_t == 'table'
      assert coercable(val), 'cannot interpolate a table that has no __tostring metamethod'
    elseif val_t ~= 'number' and val_t ~= 'boolean'
      error 'interpolation only works with strings, numbers, booleans, and tables'
    return tostring val

return {
  :Stack
  :add_index
  :assign
  :coercable
  :escape
  :get_keys
  :noop
  :repr
  :stringify
}
