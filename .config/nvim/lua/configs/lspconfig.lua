local status = pcall(require, "lspconfig")
if not status then
	return
end

--vim.lsp.set_log_level("debug")

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- nvim-cmp setup
local cmp = require("cmp")
-- local luasnip = require('luasnip') -- luasnip setup
local lspkind = require("lspkind")
lspkind.init()

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		--   ['<Tab>'] = function(fallback)
		--     if cmp.visible() then
		--       cmp.select_next_item()
		--     elseif luasnip.expand_or_jumpable() then
		--       luasnip.expand_or_jump()
		--     else
		--       fallback()
		--     end
		--   end,
		--   ['<S-Tab>'] = function(fallback)
		--     if cmp.visible() then
		--       cmp.select_prev_item()
		--     elseif luasnip.jumpable(-1) then
		--       luasnip.jump(-1)
		--     else
		--       fallback()
		--     end
		--   end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "calc" },
		{ name = "emoji" },
		{ name = "spell" },
		{ name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
		{ name = "luasnip" },
		{ name = "cmp_tabnine" },
	}, {
		{ name = "buffer" },
	}),
	formatting = {
		format = function(entry, vim_item)
			local source_mapping = {
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				cmp_tabnine = "[TN]",
				path = "[Path]",
			}

			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]
			if entry.source.name == "cmp_tabnine" then
				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
					menu = entry.completion_item.data.detail .. " " .. menu
				end
				vim_item.kind = ""
			end
			vim_item.menu = menu
			return vim_item
		end,
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			return client.name == "null-ls"
		end,
	})
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	--Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
	buf_set_keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

	buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("v", "<leader>ca", ":<c-u>lua vim.lsp.buf.range_code_action()<CR>", opts)
	buf_set_keymap("n", "<C-q>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("i", "<C-q>", "<cmd>lua vim.lsp.buf.completion()<CR>", opts)

	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

	buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	buf_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	-- buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts) -- use folke/trouble.nvim keymaps instead
	-- buf_set_keymap('n', '<leader>gl', '<cmd>lua vim.diagnostic.setqflist()<CR>.', opts)
	buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

	-- formatting
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr) -- to avoid LSP formatting conflicts
			end,
		})
	end
end

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "..",
	ignored_file_types = { -- default is not to ignore
		-- uncomment to ignore in lua:
		-- lua = true
	},
})

-- LSP servers
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
	ensure_installed = {
		"tailwindcss",
		"lua_ls",

		"gopls",
		"golangci_lint_ls",

		"tsserver",
		"html",
		"solc",

		"rust_analyzer",
		"ansiblels",
		"yamlls",

		"clangd",
	},
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
		})
	end,
})

-- formatters and linters
local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.completion.spell,

		-- null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.formatting.prettierd,

		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.diagnostics.golangci_lint,

		null_ls.builtins.diagnostics.buf,
	},
	debug = false,
	on_attach = function(client, bufnr) -- sync formatting on save
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			--   group = augroup,
			--   buffer = bufnr,
			--   callback = function()
			--     vim.lsp.buf.format({ bufnr = bufnr })
			--   end,
			-- })
		end
	end,
})

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	-- This sets the spacing and the prefix, obviously.
	virtual_text = {
		spacing = 4,
	},
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = false,
})
