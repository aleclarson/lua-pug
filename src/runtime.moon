{:escape, :noop} = require 'pug.utils'
{:concat} = table

-- The `runtime` is the fenv for render functions.
runtime =
  :tostring

  escape: (val) ->
    escape tostring val

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
        key, val = next obj, prev
        return val
    return obj

  ipairs: (obj) ->
    if obj ~= nil
      return ipairs obj
    return noop

return runtime
