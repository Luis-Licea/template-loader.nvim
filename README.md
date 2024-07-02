# template-loader.nvim

Automatically load templates based on file names and extensions.

## Installation

Install using [lazy.nvim] in `~/.config/nvim/lua/plugins/template-loader.lua`:

```lua
return {
    'Luis-Licea/template-loader.nvim',
    config = true,
}
```

## Automatic template loading

Save the following snippet in `~/.config/nvim/templates/skeleton.c` to create a
template for files with `c` extension.

```c
#include <stdio.h>
int main() {
  printf("I am an skeleton!");
  return 0;
}
```

Now execute `nvim file.c` to load the template. Any filename with `c` extension
should work.

The plugin loads templates from `~/.config/nvim/templates/` based on the extension of `skeleton.*` files.

Templates named anything other than `skeleton.*` will be loaded only if the whole name matches. For example,
save the following snippet in `~/.config/nvim/templates/main.c`

```c
#include <stdio.h>
int main() {
  printf("I am not an skeleton file!");
  return 0;
}
```

Now execute `nvim main.c` to load the template.

## Manual template loading

Use the commands `ChooseTemplate` and `LoadTemplate` to manually load templates from `~/.config/nvim/templates/`.

`:ChooseTemplate`
```
~             ╭───────────────────── Select template to load into file ──────────────────────╮
~             │>                                                                      61 / 61│
~             ├──────────────────────────────────────────────────────────────────────────────┤
~             │> /home/luis/.config/nvim/templates/.editorconfig                             │
~             │  /home/luis/.config/nvim/templates/.eslintrc.yml                             │
~             │  /home/luis/.config/nvim/templates/.prettierrc.yml                           │
~             │  /home/luis/.config/nvim/templates/.stylua.toml                              │
~             │  /home/luis/.config/nvim/templates/CMakeLists.txt                            │
~             │  /home/luis/.config/nvim/templates/code-review.md                            │
~             │  /home/luis/.config/nvim/templates/debug.md                                  │
~             │  /home/luis/.config/nvim/templates/skeleton.bash                             │
~             │  /home/luis/.config/nvim/templates/skeleton.c                                │
~             │  /home/luis/.config/nvim/templates/skeleton.js                               │
~             │  /home/luis/.config/nvim/templates/skeleton.py                               │
~             ╰──────────────────────────────────────────────────────────────────────────────╯
```

`:LoatTemplate <tab>`
```
~           ╭───────────────────────────────────────────────────────────────────────╮
~           │ /home/luis/.config/nvim/templates/.editorconfig            󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/.eslintrc.yml            󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/.prettierrc.yml          󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/.stylua.toml             󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/CMakeLists.txt           󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/code-review.md           󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/debug.md                 󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/skeleton.bash            󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/skeleton.c               󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/skeleton.js              󰀫 Variable │
~           │ /home/luis/.config/nvim/templates/skeleton.py              󰀫 Variable │
▊    [No ╰───────────────────────────────────────────────────────────────────────╯                                                                                                                     Top ▁▁
:LoadTemplate /home/luis/.config/nvim/templates/.editorconfig
```


[lazy.nvim]: https://github.com/folke/lazy.nvim
