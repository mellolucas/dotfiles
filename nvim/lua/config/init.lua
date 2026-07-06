-- Load user configuration modules
-- Convention: the module that uses a plugin owns its vim.pack.add call
require("config.options")
pcall(vim.cmd.colorscheme, "catppuccin")
require("config.commands")
-- require("config.autocmds")
-- require("config.plugins")
require("config.lsp")
require("config.keymaps")

