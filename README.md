# nvim_git_blame

A small Neovim plugin to show Git blame information for your files and lines.

## Features

- `:BlameCurrentLine` - Show Git blame information for the **current line** in central pop up.

## Installation

### Using `lazy.nvim`

Add this to your plugin list:

```lua
{
  'W-E-Robinson/nvim_git_blame',
  config = function()
      require("git_blame").setup()
      vim.keymap.set("n", "<leader>bcl", vim.cmd.BlameCurrentLine)
  end
}
```
