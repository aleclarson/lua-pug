{:get_keys, :Stack} = require 'pug.utils'
{:concat} = table

-- TODO: Support aliases and auto-suffixing.
to_css = (values) ->
  props = Stack!
  for key, value in pairs values
    if value then props\push key .. ': ' .. tostring value
  return concat props, '; '

parse_css = (props, style) ->
  for prop in props\gmatch '[^;]+'
    prop = prop\gmatch '[^:%s]+'
    style[prop!] = prop!
  return style

-- TODO: Support class map (where key is used if non-falsy value)
-- TODO: Flatten class tables
merge_attrs = (a, b) ->
  for name, val in pairs b
    if val and val ~= ''
      val_t = type val

      -- Classes are merged.
      if name == 'class'
        a.class = {} if a.class == nil
        if val_t == 'string'
          for name in val\gmatch '%S+'
            a.class[val] = true if name ~= ''
        else if val_t == 'table'
          for name in *val
            name_t = type name
            if name_t == 'number'
              a.class[name] = true
            elseif name_t == 'string'
              for name in *name\split ' '
                a.class[name] = true if name ~= ''

      -- Styles are merged.
      elseif name == 'style'
        a.style = {} if a.style == nil
        if val_t == 'string'
          parse_css val, a.style
        elseif val_t == 'table'
          for name, val in pairs val
            a.style[name] = val

      -- Use the `b` value of other attributes.
      else a[name] = val

  -- Return the first table.
  return a

exports = {}

exports.merge_attrs = (...) ->
  attrs = {}

  count = select '#', ...
  if count ~= 0

    for i = 1, count
      block = select i, ...
      if type(block) == 'table'
        merge_attrs attrs, block

    if attrs.class
      attrs.class = concat get_keys(attrs.class), ' '

    if attrs.style
      attrs.style = to_css attrs.style

  return attrs

return exports
