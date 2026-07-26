require("recycle-bin"):setup()

require("lin-decompress"):setup({
 -- Global commands for all .tar.* archives (e.g. .tar.lz, .tar.lzo, .tar.gz)
 global_tar_compressor = {
  -- Commands for each .tar.* archive,
  -- Appends these 'cmd's only if 'no_global_tar = false' is set for a .tar.* configuration below
  cmd = { "-dkc" },
 },

 -- NOTE: Use the '[name of mimetype]' portion when defining new extractors'
 --
 -- Schema:
 -- ["application/[<name of mimetype>]"] ={
 --  tool_name = "Name of tool to use for this mimetype",
 --  cmd = { list of arguments to use},
 --  no_global_tar = true (default: false) (Appends the commands specified in the 'global_tar_compressor.cmd')
 --  exts = {extension_name = true, ...} (Extension names of the archive to extract. Used only as a fallback in case mime detection fails)
 -- }
 -- Configurations for compressors commonly used with .tar.*
 tar_compressors = {
  ["lz4"] = {
   tool_name = "lz4",
   exts = {
    lz4 = true,
   },
  },
  ["xz"] = {
   tool_name = "xz",
   cmd = { "-T0" },
   exts = {
    xz = true,
   },
  },
  ["gzip"] = {
   tool_name = "gzip",
   exts = {
    gz = true,
   },
  },
  ["compress"] = {
   tool_name = "uncompress",
   exts = {
    Z = true,
   },
  },
  ["bzip2"] = {
   tool_name = "bzip2",
   exts = {
    bz2 = true,
   },
  },
  ["zstd"] = {
   tool_name = "zstd",
   cmd = { "-T0" },
   exts = {
    zst = true,
   },
  },
  ["lzop"] = {
   tool_name = "lzop",
   exts = {
    lzo = true,
   },
  },
  ["lzip"] = {
   tool_name = "lzip",
   exts = {
    lz = true,
   },
  },
  ["lzma"] = {
   tool_name = "lzma",
   exts = {
    lzma = true,
   },
  },
 },
 -- NOTE: Use the '[name of mimetype]' portion when defining new extractors'
 --
 -- Schema:
 -- ["application/[name of mimetype]"] ={
 --  tool_name = "Name of tool to use",
 --  cmd = {list of arguments to use },
 --  out_cmd = "The command to output extracted content",
 --  pw_cmd = "Command to input a Password"
 --  exts = {extension_name = true, ...} (Extension names of the archive to extract. Used only as a fallback in case mime detection fails)
 -- }
 -- Configurations for non .tar archives
 other_compressors = {
  ["rar"] = {
   tool_name = "unrar",
   cmd = { "x" },
   out_cmd = "-op",
   pw_cmd = "-p",
   exts = {
    rar = true,
   },
  },
  -- The default tool to use to extract ALL types of archive files
  ["default"] = {
   tool_name = "7z",
   cmd = { "x", "-mmt=0" },
   out_cmd = "-o",
   pw_cmd = "-p",
  },
 },
})

require("gvfs"):setup({
  -- (Optional) Save file.
  -- Default: ~/.config/yazi/gvfs.private
  save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",

  -- (Optional) Save file for automount devices. Use with `automount-when-cd` action.
  -- Default: ~/.config/yazi/gvfs_automounts.private
  save_path_automounts = os.getenv("HOME") .. "/.config/yazi/gvfs_automounts.private",

  -- (Optional) Input box position.
  -- Default: { "top-center", y = 3, w = 60 },
  -- Position, which is a table:
  -- 	`1`: Origin position, available values: "top-left", "top-center", "top-right",
  -- 	     "bottom-left", "bottom-center", "bottom-right", "center", and "hovered".
  --         "hovered" is the position of hovered file/folder
  -- 	`x`: X offset from the origin position.
  -- 	`y`: Y offset from the origin position.
  -- 	`w`: Width of the input.
  -- 	`h`: Height of the input.
  input_position = { "center", y = 0, w = 60 },

  -- (Optional) Select where to save passwords.
  -- Default: nil
  -- Available options: "keyring", "pass", or nil
  password_vault = "keyring",


  -- (Optional) Auto-save password after mount.
  -- Default: false
  save_password_autoconfirm = true,
  -- (Optional) mountpoint of gvfs. Default: /run/user/USER_ID/gvfs
  -- On some system it could be ~/.gvfs
  -- You can't decide this path, it will be created automatically. Only changed if you know where gvfs mountpoint is.
  -- Use command `ps aux | grep gvfs` to search for gvfs process and get the mountpoint path.
  -- root_mountpoint = (os.getenv("XDG_RUNTIME_DIR") or ("/run/user/" .. ya.uid())) .. "/gvfs"
})

if os.getenv("YAZI_SCRIPT_MODE") ~= "1" then
	require("autosession"):setup()
end

require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

local ok, noctalia = pcall(require, "noctalia-colors")
if not ok then noctalia = {} end -- safe fallback if not generated yet

local config_dir = os.getenv("HOME") .. "/.config/yazi/"
local ok, noctalia = pcall(dofile, config_dir .. "noctalia-colors.lua")

-- If it fails, throw a notification so you know immediately, and set an ugly red so it's obvious!
if not ok then
	ya.notify({ title = "Yatline", content = "Could not load noctalia-colors.lua!", timeout = 5 })
	noctalia = { accent = "#ff0000", bg = "#000000", fg = "#ffffff", stashes_color = "#555555" }
end

require("yatline"):setup({
	-- 2. Pure dynamic mapping (removed the 'or "white"' fallbacks)
	style_a = {
		bg = noctalia.accent,
		fg = noctalia.on_accent,
		bg_mode = {
			normal = noctalia.accent,
			select = noctalia.tag_color,
			un_set = noctalia.behind_remote_color,
		},
	},
	
	-- Keep style_b slightly different from style_c so the separator arrow stays visible
	style_b = { bg = noctalia.stashes_color, fg = noctalia.fg },
	style_c = { bg = noctalia.bg,            fg = noctalia.fg },

    -- Map your permissions dashes directly to your theme's fg so they don't vanish
	permissions_s_fg = noctalia.fg,

header_line = {
		left = {
			section_a = {
				{ type = "line", name = "tabs" },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", name = "date", params = { "%A, %d %B %Y" } },
			},
			section_b = {
				{ type = "string", name = "date", params = { "%X" } },
			},
			section_c = {
				-- ADD GITHEAD HERE: (Top Right, innermost section)
				{ type = "coloreds", custom = false, name = "githead" },
			},
		},
	},

	status_line = {
		left = {
			section_a = { { type = "string", name = "tab_mode" } },
			section_b = { { type = "string", name = "hovered_size" } },
			section_c = {
				{ type = "string", name = "hovered_path" },
				{ type = "coloreds", name = "count" },
			},
		},
		right = {
			section_a = { { type = "string", name = "cursor_position" } },
			section_b = { { type = "string", name = "cursor_percentage" } },
			section_c = {
				{ type = "string", name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", name = "permissions" },
			},
		},
	},
})

require("yatline-githead"):setup({
	order = {
		"branch", "remote", "tag", "commit",
		"behind_ahead_remote", "stashes", "state",
		"staged", "unstaged", "untracked",
	},

	show_numbers 		 = true, -- shows staged, unstaged, untracked, stashes count

	show_branch 		 = true,
	branch_prefix        = "",
	branch_color         = noctalia.branch_color,
	branch_symbol 		 = "",
	branch_borders		 = "",

	show_remote_branch   = true, -- only shown if different from local branch
	always_show_remote_branch = false, -- always show remote branch even if it the same as local branch
	always_show_remote_repo = false, -- Adds `origin/` if `always_show_remote_branch` is enabled
	remote_branch_prefix = ":",
	remote_branch_color  = noctalia.remote_branch_color,

	show_tag 			 = true, -- only shown if branch is not available
	always_show_tag 	 = false,
	tag_color            = noctalia.tag_color,
	tag_symbol 			 = "#",

	show_commit 		 = true, -- only shown if branch AND tag are not available
	always_show_commit 	 = false,
	commit_color         = noctalia.commit_color,
	commit_symbol 		 = "@",

	show_behind_ahead_remote = true,
	behind_remote_color  = noctalia.behind_remote_color,
	behind_remote_symbol = "⇣",
	ahead_remote_color   = noctalia.ahead_remote_color,
	ahead_remote_symbol  = "⇡",

	show_stashes 		 = true,
	stashes_color        = noctalia.stashes_color,
	stashes_symbol 		 = "$",

	show_state 			 = true,
	show_state_prefix 	 = true,
	state_color          = noctalia.state_color,
	state_symbol 		 = "~",

	show_staged 		 = true,
	staged_color         = noctalia.staged_color,
	staged_symbol 		 = "~",

	show_unstaged 		 = true,
	unstaged_color       = noctalia.unstaged_color,
	unstaged_symbol 	 = "!",

	show_untracked 		 = true,
	untracked_color      = noctalia.untracked_color,
	untracked_symbol 	 = "?",
	
})
