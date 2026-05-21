-- local dft_capabilities = vim.lsp.protocol.make_client_capabilities()
-- dft_capabilities.general = dft_capabilities.general or {}
-- dft_capabilities.general.positionEncodings = { "utf-16" }

return {
	-- neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		event = "LazyFile",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			-- c/c++
			"p00f/clangd_extensions.nvim",
		},
		opts = {
			-- 全局诊断配置：减少 CPU 占用
			diagnostics = {
				update_in_insert = false, -- 不在插入模式更新诊断
				virtual_text = {
					spacing = 4,
					prefix = "●",
				},
			},
			servers = {
				clangd = {
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" },
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=google",
						"--log=error",
						-- "-j=4", -- 限制后台索引并发数
						"--pch-storage=memory", -- PCH 存储在内存中（更快但要注意内存）
						"--background-index-priority=low", -- 后台索引低优先级
					},
				},
				-- gopls 配置见 lua/plugins/lang-go.lua
			},
			setup = {},
		},
	},
}
