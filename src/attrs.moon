{:get_keys, :Stack} = require 'pug.utils'
{:concat} = table

-- TODO: Use platform-agnostic string.split

-- TODO: Support aliases and auto-suffixing.
to_css = (values) ->
  props = Stack!
  for key, value in pairs values
    if value then props\push key .. ': ' .. tostring value
  return concat props, '; '

parse_css = (pairs, style) ->
  for pair in *pairs\split ';'
    pair = pair\split ':'
    style[pair[1]] = pair[2]
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
          for name in *val\split ' '
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

exports = {}

exports.merge_attrs = (attrs, blocks) ->

  if type(attrs) == 'table'
    attrs = merge_attrs {}, attrs
  else attrs = {}

  for block in *blocks
    if type(block) == 'table'
      merge_attrs attrs, block

  if attrs.class
    attrs.class = concat get_keys(attrs.class), ' '

  if attrs.style
    attrs.style = to_css attrs.style

  return attrs

return exports
