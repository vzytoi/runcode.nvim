# runcode.nvim

This project is currently not intended to run large projects  but is perfect for performance testing or troubleshooting.<br/>
If you just need to run some code quickly this plugin could be for you

## Installation & setup

Just install it using your favorite plugin manager.<br/>
Calling the setup function is not required, it is necessary if you want to add languages to the already supported list

```lua
use {
    "vzytoi/runcode.nvim",
    config = function()
        require('runcode').setup {
            ocaml = "ocaml %",
            c = "gcc % -o $ && $"
        }
    end
}
```

## How to use

```lua
vim.keymap.set("n", "<leader>x", function()
    require('runcode').open()
end)

-- You can also call open() with a string:
-- "vertical", "horizontal" or "tab".

```

## Supported list

Here is the list of languages already supported.<br/>
Of course all of them can be overridden and others added. 

| Language   | Command             | Project
|------------|---------------------|--------------------
| typescript | ts-node %           | ✖
| javascript | node %              | ✖
| go         | go run %            | ✖
| php        | php %               | ✖
| python     | python3 %           | ✖
| lua        | lua %               | ✖
| c          | gcc % -o #@ && #@   | ✖
| rust       | rustc % -o #@ && #@ | ✖
| ocaml      | ocaml %             | ✖

## How to create yours

As shown in the installation section, call the setup function and add the languages you want.<br/>
Here are the expressions being substituted

| Expression | Substitution                         | 
|------------|--------------------------------------|
| %          | `vim.fn.expand('%:p')`               |
| @          | `vim.fn.expand('%:t:r')`             |
| #          | `vim.fn.stdpath('data')..'/rooter/'` |

The `#` expression should be use to store executables before execution.

If an expression is missing, make an issue or a pull request.<br/>
The expression list can be found in _runcode/parser.lua_. 

## Goal

- Automatic project detection.
- More language support
- Aesthetic loading
- Compile xor interpret languages supporting it

## Insipiration / Alternatives

[vim-executioner](https://github.com/EvanQuan/vim-executioner)<br/>
[executor.nvim](https://github.com/google/executor.nvim)

