-- ===============================
-- Neovim 0.11 init.lua
-- ===============================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===============================
-- Editor options
-- ===============================
vim.cmd("set number")          -- show absolute line numbers
vim.cmd("set relativenumber")  -- show relative line numbers
vim.cmd("set autoindent")      -- auto-indent new lines
vim.cmd("set tabstop=4")       -- tabs = 4 spaces
vim.cmd("set shiftwidth=4")    -- indentation amount for >>
vim.cmd("set smarttab")        -- use shiftwidth for <Tab>
vim.cmd("set softtabstop=4")   -- editing tabs as 4 spaces

-- ===============================
-- Plugins
-- ===============================
require("lazy").setup({
  -- Colorscheme
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- File explorer
  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },

  -- Telescope (fuzzy finder)
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

  -- LSP management
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" }, -- snippets
})

-- ===============================
-- Nvim-tree config
-- ===============================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = { width = 30, side = "left" },
  renderer = {
    icons = {
      show = { git = true, folder = true, file = true },
    },
  },
})
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- ===============================
-- Telescope config
-- ===============================
require("telescope").setup({
  defaults = { layout_strategy = "horizontal", sorting_strategy = "ascending" },
})
vim.keymap.set("n", "<Leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- ===============================
-- LSP + Mason setup (Pyright)
-- ===============================
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright" },
})

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})

-- ===============================
-- Autocompletion (nvim-cmp)
-- ===============================
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

