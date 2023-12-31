local term = require("wezterm")

local M = {}

function M.options(config)
	-- local wsl_domains = term.default_wsl_domains()
	local wsl_domains = {
		{
			name = "WSL:Ubuntu-22.04",
			distribution = "Ubuntu-22.04",
			username = "splinks",
			default_cwd = "/home/splinks",
			default_prog = { "zsh" },
		},
		{
			name = "WSL:Ubuntu-20.04",
			distribution = "Ubuntu-20.04",
			username = "splink",
			default_cwd = "/home/splink",
			default_prog = { "zsh" },
		},
	}

	-- local ssh_domains = term.default_ssh_domains() -- Load SSH Domains from ~/.ssh/config

	-- local extra_ssh = {
	-- 	{
	-- 		name = "ArchX",
	-- 		remote_address = "192.168.110.182",
	-- 		username = "artifex",
	-- 	},
	-- 	{
	-- 		name = "ubuntu.server",
	-- 		remote_address = "192.168.110.174",
	-- 		username = "artifex",
	-- 	},
	-- 	{
	-- 		name = "Master",
	-- 		remote_address = "192.168.110.100",
	-- 		username = "artifex",
	-- 	},
	-- }

	-- for _, domain in ipairs(extra_ssh) do
	-- 	table.insert(ssh_domains, domain)
	-- end

	-- config.ssh_domains = ssh_domains

	-- config.win32_system_backdrop = "Acrylic"
	config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "-NoLogo" }
	-- config.default_prog = { "C:\\Users\\Administrator\\scoop\\apps\\git\\current\\bin\\bash.exe -li" }
	-- config.default_gui_startup_args = { "connect", "SSHMUX:192.168.110.182" }

	for _, domain in ipairs(wsl_domains) do
		domain.default_cwd = "~"
	end

	-- Using latest features
	config.prefer_egl = true

	config.launch_menu = {
		{
			label = " PowerShell",
			args = { "powershell.exe", "-NoLogo" },
		},
		{
			label = " Admin Powershell",
			args = { "pwsh", "-NoLogo", "-NoExit", "-Command", "Start-Process powershell -Verb RunAs" },
		},
		{
			label = " WSL cwd",
			args = { "wsl" },
		},
		{ label = " Cmd", args = { "cmd" } },
		{
			label = " Nvim Config",
			args = { "-Command", "cd C:/Users/linka/.config/nvim && nvim" },
		},
		-- { label = " Bash", args = { "C:/Program Files/Git/bin/bash.exe", "-li" } },
		-- { label = " Ubuntu-20", args = { "wsl.exe -d Ubuntu-20.04" } },
		-- { label = " Nushell", args = { "nu" } },
	}
end

return M
