local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
local gopls_cmd = vim.fn.exepath("gopls")
if gopls_cmd == "" then
	gopls_cmd = mason_bin .. "/gopls"
end

return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					cmd = { gopls_cmd },
					settings = {
						gopls = {
							gofumpt = true,
							usePlaceholders = true,
							completeUnimported = true,
							-- staticcheck 会报 ST1000/ST1003 等风格类提示，GoLand/VS Code 默认通常不开
							staticcheck = false,
							directoryFilters = {
								"-.git",
								"-node_modules",
								"-build",
								"-vendor",
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
						},
					},
				},
			},
		},
	},
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"gopls",
				"goimports",
				"gofumpt",
				"delve",
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			-- 避免 golangci-lint 并行锁冲突导致打开 Go 文件时报错
			opts.linters_by_ft.go = {}
		end,
	},
}
