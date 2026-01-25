# nvim-git-blame

A small Neovim plugin to show Git blame information for your files and lines.

## Features

- `:BlameCurrentLine` - Show Git blame information for the **current line** in central pop up.

## Installation

### Using `lazy.nvim`

```lua
{
  'W-E-Robinson/nvim_git_blame',
  config = function()
      require("git_blame").setup()
      vim.keymap.set("n", "<leader>bcl", vim.cmd.BlameCurrentLine)
  end
}
```

## Usage
...

## License
MIT

mention 'q' to close

make file stuf
