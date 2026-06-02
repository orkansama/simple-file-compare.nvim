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
