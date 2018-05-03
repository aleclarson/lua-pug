{:escape, :noop, :stringify} = require 'pug.utils'
{:concat} = table

-- The `runtime` is the fenv for render functions.
runtime =
  :tostring
  :escape

  __str: stringify

  __esc: (val) -> escape stringify val

  __attr: (val) -> -- Preserve nil/true/false
    val and val ~= true and stringify(val) or val

  __esca: (val) -> -- Preserve nil/true/false
    val and val ~= true and escape(stringify val) or val

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
