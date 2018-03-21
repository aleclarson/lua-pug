# lua-pug v0.1.0

This package generates HTML from a https://github.com/pugjs/pug AST.

```lua
local pug = require('pug')

local ast = json.decode(json_ast)

-- Parse and render the AST in one go
local html = pug.render(ast, opts)

-- Parse the AST once, render it many times
local render = pug.compile(ast, opts)
local html = render(opts)
```

You must use https://github.com/aleclarson/pug2lua to generate the
Lua render function from your Pug template. You also have the option
of using MoonScript within Pug expressions/blocks.

For Atom support of MoonScript in Pug, you should use https://github.com/aleclarson/language-pug,
which expects https://github.com/OttoRobba/atom-moonscript to exist.

### Options

The following options are valid for `pug.context` or `pug.render`:

- `resolve: (ref: string, from: string) => table|function`

The `resolve` function is required if you plan to use the `include`
keyword. Otherwise, an error will be thrown. You can return an AST
table or a compiled AST render function.

The following options are only available for `render` functions:

- `globals: table`

Globals passed to `render` override the globals of `pug.context`.
