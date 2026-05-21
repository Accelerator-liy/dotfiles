local float_term_win = {
	position = "float",
	width = 0.85,
	height = 0.80,
	border = "rounded",
	keys = {
		q = "hide",
		-- 终端 insert 模式下 Esc×2 只会退出到 terminal normal，不会关窗；用下面几个键直接关
		{
			"<C-\\>",
			function(self)
				self:hide()
			end,
			mode = { "n", "t" },
			desc = "Close terminal",
		},
		{
			"<C-/>",
			function(self)
				self:hide()
			end,
			mode = { "n", "t" },
			desc = "Close terminal",
		},
		{
			"<C-_>",
			function(self)
				self:hide()
			end,
			mode = { "n", "t" },
			desc = "Close terminal",
		},
	},
}

local function neo_tree_root()
	local root = vim.uv.cwd()
	local ok, manager = pcall(require, "neo-tree.sources.manager")
	if ok then
		local state = manager.get_state("filesystem")
		if state and state.path and state.path ~= "" then
			root = state.path
		end
	end
	return root
end

local function float_term_opts(cwd)
	return {
		cwd = cwd or (LazyVim and LazyVim.root() or vim.fn.getcwd()),
		win = vim.deepcopy(float_term_win),
	}
end

local function toggle_float_terminal()
	local Snacks = require("snacks")
	local opts = float_term_opts()
	local terminal = Snacks.terminal.get(nil, vim.tbl_extend("force", opts, { create = false }))
	if terminal and terminal:valid() then
		terminal:hide()
		return
	end
	Snacks.terminal.focus(nil, opts)
end

return {
	{
		"folke/snacks.nvim",
		opts = {
			terminal = {
				win = float_term_win,
			},
		},
		keys = {
			{
				"<leader><space>",
				function()
					Snacks.picker.files({ cwd = neo_tree_root() })
				end,
				desc = "Find Files (Neo-tree Root)",
			},
			{
				"<leader>ff",
				function()
					Snacks.picker.files({ cwd = neo_tree_root() })
				end,
				desc = "Find Files (Neo-tree Root)",
			},
			-- main: n/t 下在 Neo-tree 根目录开终端
			{
				"<c-/>",
				function()
					Snacks.terminal(nil, { cwd = neo_tree_root() })
				end,
				mode = { "n", "t" },
				desc = "Terminal (Neo-tree Root)",
			},
			-- liy: i/v 下 Ctrl+/ 切换浮动终端（避免与 main 的 n/t 行为冲突）
			{
				"<c-/>",
				toggle_float_terminal,
				desc = "Toggle Float Terminal",
				mode = { "i", "v" },
			},
			{
				"<c-_>",
				toggle_float_terminal,
				desc = "Toggle Float Terminal",
				mode = { "n", "i", "v", "t" },
			},
			{
				"<C-\\>",
				toggle_float_terminal,
				desc = "Toggle Float Terminal",
				mode = { "n", "i", "v", "t" },
			},
			{
				"<leader>ft",
				function()
					Snacks.terminal(nil, { cwd = neo_tree_root() })
				end,
				desc = "Terminal (Neo-tree Root)",
			},
			{
				"<leader>fT",
				function()
					local Snacks = require("snacks")
					local opts = float_term_opts(vim.fn.getcwd())
					local terminal = Snacks.terminal.get(nil, vim.tbl_extend("force", opts, { create = false }))
					if terminal and terminal:valid() then
						terminal:hide()
						return
					end
					Snacks.terminal.focus(nil, opts)
				end,
				desc = "Toggle Float Terminal (cwd)",
			},
		},
	},
	-- auto-formatter
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = true,
			format_on_save = function(bufnr)
				local ft = vim.bo[bufnr].filetype
				-- 禁用 C/C++ 保存时自动格式化
				local disabled_ft = { c = true, cpp = true, objc = true, objcpp = true, cuda = true }
				if disabled_ft[ft] then
					return false
				end
				return { timeout_ms = 3000, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				go = { "gofumpt", "goimports" },
				markdown = { "prettier", "markdownlint-cli2" },
				yaml = { "yamlfmt" },
				toml = { "taplo" },
				json = { "prettier" },
				css = { "prettier" },
				python = { "ruff_format" },
				typescriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				proto = { "buf" },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
				clang_format = {
					prepend_args = { "--style=file", "--fallback-style=google" },
				},
				-- python: ruff_format 替代 black + isort（ruff 内置 isort 功能）
				ruff_format = {
					prepend_args = { "--line-length", "100" },
				},
			},
		},
	},
	-- andymass/vim-matchup
	-- code block match up
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_enabled = 1
			vim.g.matchup_matchparen_hi_surround_always = 1
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_deferred_show_delay = 100 -- 延迟匹配显示，减少 CPU
			vim.g.matchup_matchparen_deferred_hide_delay = 500
			vim.g.matchup_matchparen_timeout = 300 -- 匹配超时（毫秒）
			vim.g.matchup_matchparen_insert_timeout = 60 -- 插入模式下更短的超时
		end,
	},
	-- nvim-treesitter/nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, {
					"bash",
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"regex",
					"markdown",
					"markdown_inline",
				})
			end
			opts.indent = { enable = false }
		end,
	},
	-- mfussenegger/nvim-lint
	{
		"mfussenegger/nvim-lint",
		event = "LazyFile",
		opts = {
			-- Event to trigger linters
			-- 在保存和读取文件时触发，保持实时反馈
			events = { "BufWritePost", "BufReadPost" },
			linters_by_ft = {
				-- c/c++/cmake
				c = { "cpplint" },
				cpp = { "cpplint" },
				-- fish
				fish = { "fish" },
				-- go: 由 lang-go.lua 管理，避免与 LazyVim go extra 重复触发 golangci-lint
				proto = { "protolint" },
				-- python
				python = { "ruff" },
				typescriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
			},
			-- LazyVim extension to easily override linter options
			-- or add custom linters.
			-- 注意：使用 prepend_args 追加参数，而非 args 覆盖（覆盖会丢失默认参数导致报错）
			---@type table<string,table>
			linters = {
				-- c/c++/cmake
				cpplint = {
					prepend_args = {
						"--filter=-legal/copyright,-build/include_subdir,-runtime/indentation_namespace",
						-- set line length, the default value is 80
						"--linelength=120",
					},
				},
			},
		},
	},
	-- numToStr/Comment.nvim
	{
		"numToStr/Comment.nvim",
		opts = function(_, opts)
			local ok, integration = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
			if ok then
				opts.pre_hook = integration.create_pre_hook()
			end
			return opts
		end,
	},
	-- code folder
	-- kevinhwang91/nvim-ufo
	{
		"kevinhwang91/nvim-ufo",
		event = "LazyFile",
		dependencies = {
			"kevinhwang91/promise-async",
			"neovim/nvim-lspconfig",
		},
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		config = function()
			require("ufo").setup({
				provider_selector = function()
					return { "lsp", "indent" }
				end,
			})
		end,
	},
}
