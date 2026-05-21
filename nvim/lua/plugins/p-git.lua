-- Git：行内 blame（作者/时间/说明）+ 状态栏 + 侧栏变更标记
local function setup_git_blame_hl()
	-- 偏青，避免与 Type（黄）等语法色混淆
	local ok, gruv = pcall(vim.api.nvim_get_hl, 0, { name = "GruvboxAqua", link = false })
	local fg = ok and gruv.fg and string.format("#%06x", gruv.fg) or "#8ec07c"
	vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
		fg = fg,
		italic = true,
		bold = true,
		default = true,
	})
end

return {
	{
		"lewis6991/gitsigns.nvim",
		init = function()
			vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
				group = vim.api.nvim_create_augroup("feg_git_blame_hl", { clear = true }),
				callback = setup_git_blame_hl,
				desc = "Bright git blame text on dark background",
			})
		end,
		opts = {
			-- 光标所在行末尾显示 blame（类似 IDE 行尾 Git 信息）
			current_line_blame = true,
			current_line_blame_formatter = " 󰊴 <author> · <author_time:%Y-%m-%d %H:%M> · <summary>",
			current_line_blame_opts = {
				delay = 250,
				virt_text = true,
				virt_text_pos = "eol",
				use_focus = true,
			},
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			opts.sections = opts.sections or {}
			opts.sections.lualine_x = opts.sections.lualine_x or {}
			-- 状态栏显示当前行 Git blame（与行尾 virtual text 同步）
			table.insert(opts.sections.lualine_x, 1, {
				function()
					local line = vim.b.gitsigns_blame_line
					if not line or line == "" then
						return ""
					end
					return line
				end,
				cond = function()
					return vim.b.gitsigns_blame_line ~= nil and vim.b.gitsigns_blame_line ~= ""
				end,
				color = function()
					local hl = vim.api.nvim_get_hl(0, { name = "GitSignsCurrentLineBlame", link = false })
					return {
						fg = hl.fg and string.format("#%06x", hl.fg) or "#8ec07c",
						gui = "bold,italic",
					}
				end,
			})
			return opts
		end,
	},
	{
		"gitsigns.nvim",
		opts = function()
			Snacks.toggle({
				name = "Git Line Blame",
				get = function()
					return require("gitsigns.config").config.current_line_blame
				end,
				set = function(state)
					require("gitsigns").toggle_current_line_blame(state)
				end,
			}):map("<leader>uB")
		end,
	},
}
