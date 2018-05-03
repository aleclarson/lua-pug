# lua-pug v0.2.0

This package generates HTML from a https://github.com/pugjs/pug AST.

```lua
local pug = require('pug')

-- Create an HTML renderer.
local render = pug{
  template = 'div !{greeting}, #[b name]!',
  globals = { greeting = '<em>Hola</em>' },
}

-- Render some HTML!
local html = render{
  globals = { name = 'Señorita' },
}
```

You must use https://github.com/aleclarson/pug2lua to generate the
Lua render function from your Pug template. You also have the option
of using MoonScript within Pug expressions/blocks.

For Atom support of MoonScript in Pug, you should use https://github.com/aleclarson/language-pug,
which expects https://github.com/OttoRobba/atom-moonscript to exist.

### Options

These options are supported by the `pug` function:

- `path: string`
- `render: function`
- `template: string`
- `resolve: (ref: string, parent: string) => function|string`
- `globals: table`
- `mixins: { string => function }`

The `path` string can be used by your `resolve` function to
identify which template contains the `include` statement
being resolved. Other than that, it's useless.

You **must** define `render` or `template`. Typically, you will
being using the `template` option. Remember that the `mixins`
option is ignored when using the `template` option. It's
expected that your template string will return a `render`
function and an optional `mixins` table.

The `resolve` function is required if you plan to use the `include`
keyword. Otherwise, the `include` is silently skipped. You can return
a render function or an HTML string.

You can pass the same `globals` table for every template if you
desire. Templates will not be able to modify it. By default,
nothing is provided to templates (even `_G` variables) except
the runtime required to render HTML.

The `pug` function returns a `render` function that you can call
unlimited times to generate HTML.

These options are recognized by the `render` function:

- `resolve: function`
- `globals: table`
- `mixins: table`

Passing `globals` to a `render` function will shadow any `globals`
provided when creating the `render` function, but you will still
have access to unshadowed globals. Same goes for the `mixins` table.

Remember that an **included** template will always use the same
`globals` as its parent template. If the included template defines
its own global variables, they won't leak into the parent template.
Any mutations to global variables won't leak either (except table mutations).

