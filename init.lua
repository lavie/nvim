
-- Set leader key
vim.g.mapleader = " "

-- Set options
vim.opt.autochdir = true
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.tabstop = 4

-- Key mappings
vim.api.nvim_set_keymap('n', '<C-j>', '10jzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '10kzz', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>l', ':set list!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-Enter>', 'O<Esc>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-left>', ':bp<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-right>', ':bn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '+', ':vert resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '-', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '=', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '_', ':vert resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ve', ':e $MYVIMRC<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':bprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':bnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true })




local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

require("lualine").setup()


local configs = require('lspconfig.configs')
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

if not configs.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = {"helm_ls", "serve"},
      filetypes = {'helm'},
      root_dir = function(fname)
        return util.root_pattern('Chart.yaml')(fname)
      end,
    },
  }
end


-- Setup language servers.
lspconfig.lua_ls.setup{}
lspconfig.tsserver.setup{}
lspconfig.gopls.setup{}
lspconfig.yamlls.setup{}
lspconfig.helm_ls.setup {
  filetypes = {"helm"},
  cmd = {"helm_ls", "serve"},
}



-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

-- require("hardline").setup {
--     bufferline = true
-- }

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', ':Telescope find_files cwd=~/tensorleap<CR>')
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep cwd=~/tensorleap<CR>')
vim.keymap.set('n', '<leader>o', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>')
vim.keymap.set('n', '<leader>bo', ':BufOnly<CR>')


vim.api.nvim_set_keymap('n', '<Leader>q', ':Sayonara<CR>', { noremap = true, silent = true})


local gpconf = {
    agents = {
		{
			name = "ChatGPT4",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-4-1106-preview", temperature = 1.1, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are a general AI assistant.\n\n"
				.. "The user provided the additional info about how they would like you to respond:\n\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide better answer.\n"
				.. "- Think deeply and carefully from first principles step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't elide any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n",
		},
		{
			name = "ChatGPT3-5",
			chat = true,
			command = false,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-3.5-turbo-1106", temperature = 1.1, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are a general AI assistant.\n\n"
				.. "The user provided the additional info about how they would like you to respond:\n\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide better answer.\n"
				.. "- Think deeply and carefully from first principles step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't elide any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n",
		},
		{
			name = "CodeGPT4",
			chat = false,
			command = true,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-4-1106-preview", temperature = 0.8, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are an AI working as a code editor.\n\n"
				.. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
				.. "START AND END YOUR ANSWER WITH:\n\n```",
		},
		{
			name = "CodeGPT3-5",
			chat = false,
			command = true,
			-- string with model name or table with model name and parameters
			model = { model = "gpt-3.5-turbo-1106", temperature = 0.8, top_p = 1 },
			-- system prompt (use this to specify the persona/role of the AI)
			system_prompt = "You are an AI working as a code editor.\n\n"
				.. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
				.. "START AND END YOUR ANSWER WITH:\n\n```",
		},
	},
}

require('gp').setup(gpconf)

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require("bufferline").setup{}
-- empty setup using defaults
require("nvim-tree").setup()

vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>')

-- Copilot
-- require('octo').setup()

require('Comment').setup()



-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
window = {
  -- completion = cmp.config.window.bordered(),
  -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  -- { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['tsserver'].setup {
capabilities = capabilities
}
require('lspconfig')['gopls'].setup {
capabilities = capabilities
}
require('lspconfig')['lua_ls'].setup {
capabilities = capabilities
}
require('lspconfig')['yamlls'].setup {
capabilities = capabilities
}

vim.api.nvim_set_keymap('n', '<BS>', ':nohlsearch<CR>', { noremap = true, silent = true })

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

vim.cmd[[colorscheme sonokai]]

vim.cmd [[autocmd BufWritePre *.ts lua vim.lsp.buf.format()]]
vim.cmd [[autocmd BufWritePre *.lua lua vim.lsp.buf.format()]]
vim.cmd [[autocmd BufWritePre *.yaml lua vim.lsp.buf.format()]]

require("mason").setup()

