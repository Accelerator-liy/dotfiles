return {
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"prettier",
				"shfmt",
				"stylua",
				"buf",
				"protolint",
				"eslint_d",
				"gofumpt",
				"goimports",
				-- copilot 需要 Node 22+，当前环境会反复报错，已改用 Cursor Agent
				-- "copilot-language-server",
			})
		end,
		config = function(_, opts)
			require("mason").setup(opts)

			local Package = require("mason-core.package")
			local orig_install = Package.install
			function Package:install(o, cb)
				if self:is_installing() then
					return self.install_handle
				end
				return orig_install(self, o, cb)
			end

			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local ok, p = pcall(mr.get_package, tool)
					if ok and not p:is_installed() and not p:is_installing() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		enabled = true,
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls", -- Lua
				"ruff", -- Python
				"gopls", -- Go
				"rust_analyzer", -- Rust
				"clangd", -- C/C++
				"buf_ls", -- protobuf
				"ts_ls", -- typescript
			},
			automatic_installation = true,
			automatic_enable = true,
		},
	},
}
