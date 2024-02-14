vim.cmd("set shiftwidth=4 smarttab")
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
	'nvim-telescope/telescope.nvim', tag = '0.1.5',
	dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
	    "nvim-lua/plenary.nvim",
	    "nvim-tree/nvim-web-devicons",
	    "MunifTanjim/nui.nvim",
	}
    },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { 
	"L3MON4D3/LuaSnip",
	dependencies = {
	    "saadparwaiz1/cmp_luasnip",
	    "rafamadriz/friendly-snippets"
	}	
    },
    { "cdelledonne/vim-cmake" },
    { "antoinemadec/FixCursorHold.nvim" }
}
local opts = {

}
 
require("lazy").setup(plugins, opts)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})

vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {})

vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<cr>', {})
vim.keymap.set('n', '<leader>cb', ':CMakeBuild<cr>', {})
vim.keymap.set('n', '<F5>', ':!./Debug/hello', {})

local config = require("nvim-treesitter.configs")
config.setup({
    ensure_installed = {"c", "cpp"},
    highlight = { enable = true },
    indent = { enable = true },
})

require("catppuccin").setup({
    flavour = "frappe",
})
vim.cmd.colorscheme "catppuccin"

require("neo-tree").setup({
    window = {
	width = 40,
    },
})

require("telescope").setup {
    extensions = {
	["ui-select"] = {
	    require("telescope.themes").get_dropdown {}
	}
    }
}
require("telescope").load_extension("ui-select")

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "clangd" }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.clangd.setup{ capabilities = capabilities }

local cmp = require'cmp'
require("luasnip.loaders.from_vscode").load()

cmp.setup({
    snippet = {
	expand = function(args)
	    require('luasnip').lsp_expand(args.body)
	end,
    },
    window = {
	completion = cmp.config.window.bordered(),
	documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
	-- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
	-- ['<C-f>'] = cmp.mapping.scroll_docs(4),
	-- ['<C-Space>'] = cmp.mapping.complete(),
	['<C-e>'] = cmp.mapping.abort(),
	['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
	{ name = 'luasnip' },
    }, {
	{ name = 'buffer' },
    })
})
