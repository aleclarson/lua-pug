{:escape, :noop} = require 'pug.utils'
{:concat} = table

-- The `runtime` is the fenv for render functions.
runtime =
  __string: (val) ->
    -- Preserve nil/true/false
    if val and val ~= true
      return tostring val

  __escape: (val) ->
    -- Preserve nil/true/false
    if val and val ~= true
      return escape tostring val

  __each: (obj) ->
    if obj == nil
      return noop
    if type(obj) == 'table'
      return pairs obj
    return obj

  __vals: (obj) ->
    if obj == nil
      return noop
    if type(obj) == 'table'
      prev, next = 0, pairs obj
      return ->
        prev, val = next obj, prev
        return val
    return obj

  ipairs: (obj) ->
    if obj ~= nil
      return ipairs obj
    return noop

return runtime
