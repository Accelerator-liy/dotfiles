return {
	{
		"nvim-mini/mini.icons",
		lazy = false,
		opts = {
			extension = {
				md = { glyph = "󰍔", hl = "MiniIconsGrey" },
				yaml = { glyph = "󰨰", hl = "MiniIconsPurple" },
				yml = { glyph = "󰨰", hl = "MiniIconsPurple" },
				cpp = { glyph = "󰙲", hl = "MiniIconsAzure" },
				cc = { glyph = "󰙲", hl = "MiniIconsAzure" },
				h = { glyph = "󰫵", hl = "MiniIconsPurple" },
				hpp = { glyph = "󰫵", hl = "MiniIconsPurple" },
				py = { glyph = "󰌠", hl = "MiniIconsYellow" },
				sh = { glyph = "󰈹", hl = "MiniIconsGrey" },
				go = { glyph = "󰟓", hl = "MiniIconsAzure" },
			},
			file = {
				["README.md"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
				["README%.md$"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
				["%.md$"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
				["%.yaml$"] = { glyph = "󰨰", hl = "MiniIconsPurple" },
				["%.yml$"] = { glyph = "󰨰", hl = "MiniIconsPurple" },
				["%.cpp$"] = { glyph = "󰙲", hl = "MiniIconsAzure" },
				["%.cc$"] = { glyph = "󰙲", hl = "MiniIconsAzure" },
				["%.h$"] = { glyph = "󰫵", hl = "MiniIconsPurple" },
				["%.hpp$"] = { glyph = "󰫵", hl = "MiniIconsPurple" },
				["%.py$"] = { glyph = "󰌠", hl = "MiniIconsYellow" },
				["%.sh$"] = { glyph = "󰈹", hl = "MiniIconsGrey" },
				["%.go$"] = { glyph = "󰟓", hl = "MiniIconsAzure" },
			},
		},
	},
	{
		-- LazyVim 用 mini.icons 模拟 devicons，避免重复加载导致图标回退为问号
		"nvim-tree/nvim-web-devicons",
		enabled = false,
	},
	{
		"akinsho/bufferline.nvim",
		enabled = true,
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{ "<leader>bh", "<cmd>BufferLineCyclePrev<cr>", desc = "Buffer: Prev" },
			{ "<leader>bl", "<cmd>BufferLineCycleNext<cr>", desc = "Buffer: Next" },
			{ "<leader>b[", "<cmd>BufferLineMovePrev<cr>", desc = "Buffer: Move Prev" },
			{ "<leader>b]", "<cmd>BufferLineMoveNext<cr>", desc = "Buffer: Move Next" },
		},
		opts = function(_, opts)
			opts.options = opts.options or {}
			opts.options.always_show_bufferline = true
			opts.options.separator_style = "slant"
			opts.options.numbers = function(to)
				return string.format("%s", to.ordinal)
			end
			return opts
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1010,
		config = function()
			require("gruvbox").setup()
			vim.o.background = "dark"
			vim.cmd([[colorscheme gruvbox]])
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			commands = {
				go_to_parent_dir = function(state)
					local node = state.tree:get_node()
					require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
				end,
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					-- 原 / 属于旧版 codicon，很多 Nerd Font 显示为方框问号
					expander_collapsed = "󰅂",
					expander_expanded = "󰅀",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					-- 使用 Nerd Font v3 (nf-md) 图标，避免旧版  显示为方框问号
					folder_closed = "󰉋",
					folder_open = "󰝰",
					folder_empty = "󰉖",
					folder_empty_open = "󰝰",
					default = "󰈔",
					provider = function(icon, node, _state)
						if node.type ~= "file" and node.type ~= "terminal" then
							return
						end
						local MiniIcons = _G.MiniIcons or require("mini.icons")
						if not _G.MiniIcons then
							MiniIcons.setup()
						end
						local name = node.type == "terminal" and "terminal" or node.name
						local glyph, hl = MiniIcons.get("file", name)
						if glyph then
							icon.text = glyph
							icon.highlight = hl
						end
					end,
				},
				-- 右侧：文件/目录内的 LSP 诊断汇总（错误/警告等）
				diagnostics = {
					symbols = {
						error = "󰅙",
						warn = "󰀦",
						info = "󰋼",
						hint = "󰌶",
					},
				},
				-- 右侧：Git 变更状态
				git_status = {
					symbols = {
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
				},
				modified = {
					symbol = "●",
				},
			},
			window = {
				mappings = {
					["IP"] = "go_to_parent_dir",
				},
			},
		},
	},
}
