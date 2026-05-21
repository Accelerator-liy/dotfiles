-- 统一使用 Nerd Font v3 (nf-md) 图标，避免方框问号
local nf = {
	diag = {
		error = "󰅙",
		warn = "󰀦",
		info = "󰋼",
		hint = "󰌶",
	},
	git = {
		added = "󰐕",
		modified = "󰏫",
		deleted = "󰍴",
		renamed = "󰁕",
		untracked = "󰐔",
		ignored = "󰈈",
		unstaged = "󰄱",
		staged = "󰄲",
		conflict = "󰞇",
	},
	kinds = {
		Array = "󰅪 ",
		Boolean = "󰨙 ",
		Class = "󰌗 ",
		Codeium = "󰘦 ",
		Color = "󰏘 ",
		Control = "󰇒 ",
		Collapsed = "󰅂 ",
		Constant = "󰏿 ",
		Constructor = "󰆧 ",
		Copilot = "󰚦 ",
		Enum = "󰕘 ",
		EnumMember = "󰕘 ",
		Event = "󰃭 ",
		Field = "󰇽 ",
		File = "󰈔 ",
		Folder = "󰉋 ",
		Function = "󰊕 ",
		Interface = "󰛅 ",
		Key = "󰌋 ",
		Keyword = "󰌋 ",
		Method = "󰆧 ",
		Module = "󰏗 ",
		Namespace = "󰌗 ",
		Null = "󰟢 ",
		Number = "󰎠 ",
		Object = "󰀚 ",
		Operator = "󰆕 ",
		Package = "󰏗 ",
		Property = "󰈙 ",
		Reference = "󰈇 ",
		Snippet = "󰌜 ",
		String = "󰉿 ",
		Struct = "󰙅 ",
		Supermaven = "󰚦 ",
		TabNine = "󰏚 ",
		Text = "󰉿 ",
		TypeParameter = "󰊄 ",
		Unit = "󰑭 ",
		Value = "󰎠 ",
		Variable = "󰀫 ",
	},
}

return {
	{
		"folke/snacks.nvim",
		opts = {
			picker = {
				prompt = "󰍉 ",
				icons = {
					files = {
						dir = "󰉋 ",
						dir_open = "󰝰 ",
						file = "󰈔 ",
					},
					keymaps = {
						nowait = "󰓅 ",
					},
					tree = {
						vertical = "│ ",
						middle = "├╴",
						last = "└╴",
					},
					undo = {
						saved = "󰆓 ",
					},
					ui = {
						live = "󰐊 ",
						selected = "● ",
						unselected = "○ ",
					},
					git = {
						commit = "󰜘 ",
						staged = "●",
						added = "󰐕",
						deleted = "󰍴",
						ignored = "󰈈 ",
						modified = "󰏫",
						renamed = "󰁕",
						unmerged = "󰞇 ",
						untracked = "󰐔",
					},
					diagnostics = {
						Error = nf.diag.error .. " ",
						Warn = nf.diag.warn .. " ",
						Hint = nf.diag.hint .. " ",
						Info = nf.diag.info .. " ",
					},
					lsp = {
						unavailable = "󰍴",
						enabled = "󰈈 ",
						disabled = "󰈉 ",
						attached = "󰖩 ",
					},
					kinds = nf.kinds,
				},
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			opts.options = opts.options or {}
			-- 不用 Powerline 字符 ()，改用 nf-md + 竖线，保留分区感又不乱码
			opts.options.section_separators = { left = "▎", right = "▎" }
			opts.options.component_separators = { left = "│", right = "│" }

			local lualine_util = require("lazyvim.util.lualine")

			opts.sections.lualine_a = { "mode" }
			opts.sections.lualine_b = {
				{ "branch", icon = "󰘬 " },
			}

			-- 只改图标/路径长度，保留 diagnostics / filetype / trouble 面包屑等
			if opts.sections.lualine_c then
				opts.sections.lualine_c[1] = lualine_util.root_dir({ icon = "󰴖 " })
				opts.sections.lualine_c[4] = lualine_util.pretty_path({ length = 3 })
			end

			-- 保留 LazyVim 全部右侧组件，只替换 DAP 的 codicon 图标（固定第 4 项）
			local x = opts.sections.lualine_x
			if x and x[4] and type(x[4]) == "table" then
				local old = x[4]
				x[4] = {
					function()
						return "󰝤 " .. require("dap").status()
					end,
					cond = old.cond,
					color = old.color,
				}
			end

			opts.sections.lualine_y = {
				{ "progress", separator = " ", padding = { left = 1, right = 0 } },
				{ "location", padding = { left = 0, right = 1 } },
			}
			opts.sections.lualine_z = {
				{
					function()
						return "󰥔 " .. os.date("%R")
					end,
					padding = { left = 1, right = 1 },
				},
			}
			return opts
		end,
	},
	{
		"folke/noice.nvim",
		opts = {
			cmdline = {
				format = {
					cmdline = { icon = "󰘳" },
					search_down = { icon = "󰍉 " },
					search_up = { icon = "󰍉 " },
					filter = { icon = "󰆍" },
					lua = { icon = "󰢱" },
					help = { icon = "󰋖" },
					calculator = { icon = "󰪚" },
					input = { icon = "󰥻 " },
				},
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			icons = {
				diagnostics = {
					Error = nf.diag.error .. " ",
					Warn = nf.diag.warn .. " ",
					Hint = nf.diag.hint .. " ",
					Info = nf.diag.info .. " ",
				},
				git = {
					added = nf.git.added .. " ",
					modified = nf.git.modified .. " ",
					removed = nf.git.deleted .. " ",
				},
				kinds = nf.kinds,
				dap = {
					Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
					Breakpoint = "󰝤 ",
					BreakpointCondition = "󰟘 ",
					BreakpointRejected = { nf.diag.error .. " ", "DiagnosticError" },
					LogPoint = "󰈚 ",
				},
			},
		},
	},
}
