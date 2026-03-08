# nvim-git-blame
- [Introduction](#introduction)
- [Features](#features)
    - [BlameCurrentLine](#blamecurrentline)
    - [FilesCommitHashes](#filescommithashes)
- [Setup](#setup)
    - [Requirements](#requirements)
    - [Installation](#installation)
        - [Lazy](#lazy)
- [Development](#development)
    - [Local Plugin Setup](#localpluginsetup)
    - [Makefile Commands](#makefilecommands)
- [Future Ideas](#futureideas)

Trying my hand at Neovim plugin development with a simple Neovim plugin to show Git blame information for your files and lines.

# Table of contents
1. [Introduction](#introduction)
2. [Some paragraph](#paragraph1)
3. [Another paragraph](#paragraph2)

## This is the introduction <a name="introduction"></a>
Some introduction text, formatted in heading 2 style

## Some paragraph <a name="paragraph1"></a>
The first paragraph text

### Sub paragraph <a name="subparagraph1"></a>
This is a sub paragraph, formatted in heading

[![GitHub release](https://img.shields.io/github/v/release/W-E-Robinson/nvim-git-blame?label=latest&sort=semver)](https://github.com/W-E-Robinson/nvim-git-blame/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Features

- `:BlameCurrentLine` - Show Git blame information for the **current line** in a central pop-up.  
- Press `q` to close the pop-up.

## Installation

### Using `lazy.nvim`

```lua
{
  'W-E-Robinson/nvim-git-blame',
  -- tag = "v1.0.0", -- uncomment to use a specific version
  config = function()
      require("nvim_git_blame").setup()
      -- Map <leader>bcl to show git info for the current line
      vim.keymap.set("n", "<leader>bcl", vim.cmd.BlameCurrentLine)
  end
}
```

## Usage

Once installed:

1. Open a file tracked by Git.
2. Place your cursor on the line you want to inspect.
3. Press `<leader>bcl` or run `:BlameCurrentLine`.  
4. Press `q` to close the blame pop-up.

## Screenshot
<img width="2384" height="1422" alt="image" src="https://github.com/user-attachments/assets/1501799a-aa1c-42f0-adca-35325a0d0f6c" />

## Development

### Makefile commands

format:
```bash
make style
```

check:
```bash
make check
```

tests:
```bash
make test
```

all:
```bash
make all
```
