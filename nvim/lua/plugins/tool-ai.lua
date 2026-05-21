local agent_cmd = vim.fn.exepath("agent")
if agent_cmd == "" then
	agent_cmd = os.getenv("HOME") .. "/.local/bin/agent"
end

return {
	{
		"folke/sidekick.nvim",
		enabled = false,
	},
	{
		-- https://github.com/yetone/avante.nvim
		-- https://cursor.com/docs/cli/acp#neovim-avantenvim
		"yetone/avante.nvim",
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-mini/mini.pick",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"ibhagwan/fzf-lua",
			"stevearc/dressing.nvim",
			"folke/snacks.nvim",
			"nvim-mini/mini.icons",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("VimLeavePre", {
				desc = "Close avante ACP session on quit",
				callback = function()
					pcall(function()
						local sidebar = require("avante").get()
						if sidebar then
							sidebar:shutdown()
						end
					end)
				end,
			})
		end,
		config = function(_, opts)
			require("avante").setup(opts)

			local Sidebar = require("avante.sidebar")

			-- 打开侧边栏时不要自动 handle_submit("") 连 ACP，否则 agent 会在空闲时往对话框流式写 ` 等字符
			local orig_open = Sidebar.open
			Sidebar.open = function(self, open_opts)
				local orig_submit = self.handle_submit
				self.handle_submit = function(_, request)
					if request == "" then
						return
					end
					return orig_submit(self, request)
				end
				local ok, err = pcall(orig_open, self, open_opts)
				self.handle_submit = orig_submit
				if not ok then
					error(err)
				end
				return self
			end

			local function stop_acp_client(sidebar)
				if not sidebar or not sidebar.acp_client then
					return
				end
				pcall(function()
					local session_id = sidebar.chat_history and sidebar.chat_history.acp_session_id
					if session_id and sidebar.acp_client.cancel_session then
						sidebar.acp_client:cancel_session(session_id)
					end
					if sidebar.acp_client.stop then
						sidebar.acp_client:stop()
					end
				end)
				sidebar.acp_client = nil
			end

			local orig_shutdown = Sidebar.shutdown
			Sidebar.shutdown = function(self, ...)
				stop_acp_client(self)
				return orig_shutdown(self, ...)
			end

			local orig_close = Sidebar.close
			Sidebar.close = function(self, ...)
				stop_acp_client(self)
				return orig_close(self, ...)
			end
		end,
		---@module "avante"
		---@type avante.Config
		opts = {
			provider = "cursor",
			mode = "agentic",
			acp_providers = {
				cursor = {
					command = agent_cmd,
					args = { "acp" },
					auth_method = "cursor_login",
					env = {
						HOME = os.getenv("HOME"),
						PATH = os.getenv("PATH"),
					},
				},
			},
			behaviour = {
				auto_suggestions = false,
				auto_set_keymaps = true,
				-- 关闭后避免后台仍连着 agent acp 乱输出字符
				auto_approve_tool_permissions = false,
				acp_follow_agent_locations = false,
				enable_token_counting = false,
			},
			prompt_logger = {
				enabled = false,
			},
			input = {
				provider = "snacks",
				provider_opts = {
					title = "Cursor Agent",
					icon = " ",
				},
			},
			selector = {
				-- 合法值: native | fzf_lua | mini_pick | snacks | telescope（写 "fzf" 会报错并卡住选文件）
				provider = "fzf_lua",
			},
		},
		keys = {
			{
				"<leader>aa",
				function()
					require("avante.api").ask()
				end,
				desc = "Cursor Agent: Ask",
			},
			{
				"<leader>at",
				function()
					local sidebar = require("avante").get()
					if sidebar and sidebar:is_open() then
						sidebar:shutdown()
					else
						require("avante.api").toggle()
					end
				end,
				desc = "Cursor Agent: Toggle Sidebar",
			},
			{
				"<leader>az",
				function()
					require("avante.api").zen_mode()
				end,
				desc = "Cursor Agent: Zen Mode",
			},
			{
				"<leader>ae",
				function()
					require("avante.api").edit()
				end,
				mode = { "n", "v" },
				desc = "Cursor Agent: Edit Selection",
			},
			{
				"<leader>an",
				function()
					require("avante.api").new_ask()
				end,
				desc = "Cursor Agent: New Chat",
			},
		},
	},
}
