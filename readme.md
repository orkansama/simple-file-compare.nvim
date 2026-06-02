## simple-file-compare.nvim
**simple-file-compare.nvim** is a lightweight Neovim plugin that lets you compare the current file against its version on another Git branch. It opens a vertical split with a diff view, making it easy to spot changes without leaving your editor.

- Configurable picker UI: supports Snacks, `vim.ui.select`, and mini.pick
- Simple setup with a single `FileCompareOpen` command
- Quickly return to your original buffer with `FileCompareClose`

**Limitations**
- The file must exist at the same path on the target branch
- The target branch must be available locally
- `FileCompareClose` will close all other open buffers

**Demo**

https://github.com/user-attachments/assets/08f6b38d-8147-4f5a-8447-d4b487004d43

**Installation**

**Lazy**
```lua
{
  'orkansama/simple-file-compare.nvim',
  dependencies = {
    -- depending on your preference
    'folke/snacks.nvim',
    'nvim-mini/mini.pick',
  },
  config = function()
    local simpleFileCompare = require('simple-file-compare')
    simpleFileCompare.setup({
      mode = 'snacks', -- "snacks" | "vimUiSelect" | "miniPick"
    })
  end,
}
```


Any other common plugin manager should work as well, as long as you call ```require("simple-file-compare").setup()``` after installation.

## Requirements

- Git installed and available in your `PATH`
- Only tested on Neovim v0.12.2 — older versions may work but are not guaranteed

## Configuration

```lua
require("simple-file-compare").setup({
    mode = "snacks", -- default
})
```

The `mode` option controls which picker UI is used to select a branch. The following options are available, depending on your preference:

- `"snacks"` — uses [snacks.nvim](https://github.com/folke/snacks.nvim)
- `"vimUiSelect"` — uses the built-in `vim.ui.select`
- `"miniPick"` — uses [mini.pick](https://github.com/echasnovski/mini.pick)

## Contributing
- PRs, issues and ideas are welcome
- This plugin is intended to stay simple and minimal, please keep that in mind when proposing new features
