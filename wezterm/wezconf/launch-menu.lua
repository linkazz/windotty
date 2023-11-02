local term = require("wezterm")
local launch_menu = {}

-- Enumerate any WSL distributions that are installed and add those to the menu
local success, wsl_list, wsl_err = term.run_child_process({ "wsl.exe", "-l" })
if success then
	-- `wsl.exe -l` has a bug where it always outputs utf16:
	-- https://github.com/microsoft/WSL/issues/4607
	-- So we get to convert it
	wsl_list = term.utf16_to_utf8(wsl_list)
	for idx, line in ipairs(term.split_by_newlines(wsl_list)) do
		-- Skip the first line of output; it's just a header
		if idx > 1 then
			-- Remove the "(Default)" marker from the default line to arrive
			-- at the distribution name on its own
			local distro = line:gsub(" %(Default%)", "")

			-- Add an entry that will spawn into the distro with the default shell
			table.insert(launch_menu, {
				label = distro .. " (WSL default shell)",
				args = { "wsl.exe", "--distribution", distro },
			})

			-- Here's how to jump directly into some other program; in this example
			-- its a shell that probably isn't the default, but it could also be
			-- any other program that you want to run in that environment
			table.insert(launch_menu, {
				label = distro .. " (WSL zsh login shell)",
				args = {
					"wsl.exe",
					"--distribution",
					distro,
					"--exec",
					"/bin/zsh",
					"-l",
				},
			})
		end
	end
end
