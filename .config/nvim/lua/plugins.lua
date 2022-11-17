-- Auto install packer.nvim if not exists
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PackerBootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

local plugins = {
	-- Packer can manage itself as an optional plugin
	{
		"wbthomason/packer.nvim",
		event = "VimEnter",
	},
	{ "lewis6991/impatient.nvim" },
	{ "nathom/filetype.nvim" },
	{
		"nvim-lua/plenary.nvim",
		requires = { "nvim-lua/popup.nvim" },
	},

	--- Git plugins ---

	{
		"tpope/vim-fugitive",
		config = function()
			require("configs.fugitive")
		end,
	},
	{ "tpope/vim-rhubarb" },

	{
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		tag = "release", -- To the latest release
		config = function()
			require("configs.others").gitsigns()
		end,
	},

	--- UI & Theme plugins. Look & Feel ---

	{
		"arcticicestudio/nord-vim",
		disable = true,
		config = function()
			vim.cmd("colorscheme nord")
		end,
	},
	{
		"rakr/vim-one",
		disable = false,
		config = function()
			require("configs.others").vimone()
		end,
	},
	{
		"norcalli/nvim-base16.lua",
		disable = true,
		requires = { "norcalli/nvim.lua" },
		after = "packer.nvim",
		config = function()
			require("configs.base16")
		end,
	},

	{
		"kyazdani42/nvim-web-devicons",
		-- after = "nvim-base16.lua",
		config = function()
			require("configs.icons")
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = "BufRead",
		config = function()
			require("configs.colorizer")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		requires = {
			{ "kyazdani42/nvim-web-devicons", opt = true },
			{
				"SmiteshP/nvim-gps",
				requires = "nvim-treesitter/nvim-treesitter",
			},
		},
		after = "nvim-gps",
		config = function()
			require("configs.lualine")
		end,
	},
	{
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("configs.bufferline")
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("configs.others").indent_blankline()
		end,
	},

	{
		"folke/lsp-colors.nvim",
		config = function()
			require("configs.others").lsp_colors()
		end,
	},

	{
		"kyazdani42/nvim-tree.lua",
		requires = { "nvim-web-devicons", opt = true }, -- optional, for file icon
		-- cmd = { 'NvimTreeOpen', 'NvimTreeToggle', 'NvimTreeFocus' },
		setup = function()
			require("utils").set_keymap("n", ",e", "<Cmd>NvimTreeToggle<CR>")
		end,
		config = function()
			require("configs.nvimtree")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		requires = "nvim-lua/plenary.nvim",
		module = "telescope",
		cmd = "Telescope",
		setup = function()
			require("configs.others").telescope()
		end,
		config = function()
			require("configs.telescope")
		end,
	},
	{
		{
			"nvim-telescope/telescope-project.nvim",
			setup = function()
				require("utils").set_keymap("n", "'p", "<cmd>Telescope project<cr>")
			end,
		},
		{
			"nvim-telescope/telescope-file-browser.nvim",
			setup = function()
				require("utils").set_keymap("n", "'e", "<cmd>Telescope file_browser<cr>")
			end,
		},
		{
			"AckslD/nvim-neoclip.lua",
			requires = { "tami5/sqlite.lua", module = "sqlite" },
			setup = function()
				require("utils").set_keymap("n", "'y", "<cmd>lua require('telescope').extensions.neoclip.default()<cr>")
			end,
			config = function()
				require("configs.others").neoclip()
			end,
		},
		{
			"ThePrimeagen/git-worktree.nvim",
			setup = function()
				local set_keymap = require("utils").set_keymap
				set_keymap("n", "'wl", "<cmd>Telescope git_worktree git_worktrees<cr>")
				set_keymap("n", "'wc", "<cmd>Telescope git_worktree create_git_worktree<cr>")
			end,
		},
		{ "rcarriga/nvim-notify" },
		requires = "nvim-telescope/telescope.nvim",
	},

	{
		"folke/twilight.nvim",
		cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
		setup = function()
			require("utils").set_keymap("n", "<space>t", "<Cmd>Twilight<CR>")
		end,
		config = function()
			require("twilight")
		end,
	},

	{ "stevearc/dressing.nvim" },

	{
		"stevearc/aerial.nvim",
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("configs.others").aerial()
		end,
	},

	{
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		setup = function()
			local set_keymap = require("utils").set_keymap
			local opts = { silent = false }
			set_keymap("n", "<leader>xx", "<Cmd>Trouble<CR>", opts)
			set_keymap("n", "<leader>xw", "<Cmd>Trouble workspace_diagnostics<CR>", opts)
			set_keymap("n", "<leader>xd", "<Cmd>Trouble document_diagnostics<CR>", opts)
			set_keymap("n", "<leader>xl", "<Cmd>Trouble loclist<CR>", opts)
			set_keymap("n", "<leader>xq", "<Cmd>Trouble quickfix<CR>", opts)
			set_keymap("n", "gR", "<Cmd>Trouble lsp_references<CR>", opts)
		end,
		cmd = "Trouble",
		config = function()
			require("trouble").setup({})
		end,
	},

	--- LSP stuff ---

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"onsails/lspkind-nvim",
		config = function()
			require("lspkind").init()
		end,
	},

	{
		"williamboman/mason.nvim",
		requires = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup()
		end,
	},
	{ "williamboman/mason-lspconfig.nvim" },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{
		"hrsh7th/nvim-cmp",
		requires = {
			"neovim/nvim-lspconfig",
			"onsails/lspkind-nvim",
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-calc",
		"hrsh7th/cmp-emoji",
		"f3fora/cmp-spell",
		"octaltree/cmp-look",
		"saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
		"L3MON4D3/LuaSnip", -- Snippets plugin
		requires = "hrsh7th/nvim-cmp",
	},
	{
		"tzachar/cmp-tabnine",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
	},
	{ "github/copilot.vim" },

	{
		"ray-x/lsp_signature.nvim",
		after = "nvim-lspconfig",
		config = function()
			require("configs.others").lsp_signature()
		end,
	},

	{ -- syntax parsers and highlighters
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("configs.treesitter")
		end,
	},
	{ -- tresitter plugins
		"windwp/nvim-ts-autotag",
		"p00f/nvim-ts-rainbow",
		"romgrk/nvim-treesitter-context",
		{
			"nvim-treesitter/playground",
			cmd = "TSPlaygroundToggle",
			setup = function()
				require("utils").set_keymap("n", "<F8>", ":TSPlaygroundToggle<CR>")
			end,
		},
		{
			"ThePrimeagen/refactoring.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			config = function()
				require("configs.others").refactoring()
			end,
		},
		requires = "nvim-treesitter/nvim-treesitter",
		event = "BufRead",
	},

	{
		"ray-x/go.nvim",
		requires = "ray-x/guihua.lua", -- recommended if need floating window support
		config = function()
			require("configs.others").go_nvim()
		end,
	},

	--- DAP plugins ---

	{
		"mfussenegger/nvim-dap",
		module = "dap",
		config = function()
			require("configs.dap")
		end,
	},

	{
		"leoluz/nvim-dap-go",
		after = "nvim-dap",
		config = function()
			require("dap-go").setup()
			require("utils").set_keymap("n", "<leader>dt", "<cmd>lua require('dap-go').debug_test()<CR>")
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		after = "nvim-dap",
		config = function()
			require("configs.others").python_dap()
		end,
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},
		after = "nvim-dap",
		config = function()
			require("nvim-dap-virtual-text").setup({})
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		setup = function()
			require("utils").set_keymap("n", ",d", "<cmd>lua require('dapui').toggle()<CR>")
		end,
		after = "nvim-dap",
		config = function()
			require("dapui").setup()
		end,
	},

	--- Miscellaneous ---

	{
		"famiu/bufdelete.nvim",
		cmd = "Bdelete",
		setup = function()
			require("utils").set_keymap("n", "<leader>q", ":Bdelete<CR>")
		end,
	},

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	{ "tpope/vim-surround" },

	{
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
		config = function()
			require("configs.autopairs")
		end,
	},

	{
		"max397574/better-escape.nvim",
		event = "InsertCharPre",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"karb94/neoscroll.nvim",
		config = function()
			require("configs.others").neoscroll()
		end,
	},

	{
		"luukvbaal/stabilize.nvim",
		config = function()
			require("stabilize").setup()
		end,
	},

	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup()
		end,
	},

	{
		"Pocco81/TrueZen.nvim",
		cmd = { "TZAtaraxis", "TZFocus", "TZMinimalist" },
	},

	{
		"goolord/alpha-nvim",
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},

	{
		"bkad/CamelCaseMotion",
		config = function()
			require("configs.others").camelCaseMotion()
		end,
	},
	{ "ggandor/lightspeed.nvim" },
}

return require("packer").startup(function(use)
	for _, v in pairs(plugins) do
		use(v)
	end

	if PackerBootstrap then
		require("packer").sync()
	end
end)
