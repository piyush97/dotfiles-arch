-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import LazyVim plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Don't lazy-load by default
    version = false, -- Try installing the latest stable versions of plugins
  },
  install = { 
    colorscheme = { "tokyonight", "habamax" } 
  },
  checker = { 
    enabled = true, -- Automatically check for plugin updates
    notify = false, -- Don't notify on startup
  },
  performance = {
    rtp = {
      -- Disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Load LazyVim configuration
require("config.lazy")