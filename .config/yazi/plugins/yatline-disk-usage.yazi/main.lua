local state = ya.sync(function(st)
	return st
end)

local set_state = ya.sync(function(st, cwd, source, usage)
	st.cwd = cwd
	st.source = source
	st.usage = usage
	ui.render()
end)

local get_cwd = ya.sync(function(_)
	return tostring(cx.active.current.cwd)
end)

local function setup(st, _)
	local function refresh()
		local cwd = get_cwd()
		ya.emit("plugin", { st._id, ya.quote(cwd, true) })
	end

	ps.sub("cd", refresh)
	ps.sub("tab", refresh)
	ps.sub("delete", refresh)
	ps.sub("trash", refresh)
	ps.sub("move", refresh)
	ps.sub("@yank", refresh)

	if Yatline ~= nil then
		Yatline.coloreds.get["disk-usage"] = function()
			local current_cwd = tostring(cx.active.current.cwd)
			local s = state()

			if s.cwd ~= current_cwd then
				ya.emit("plugin", { st._id, ya.quote(current_cwd, true) })
			end

			if not s.usage then return {} end

			local source = (s.source or ""):gsub("^/dev/", "")
			local color
			if s.usage > 85 then
				color = "red"
			elseif s.usage >= 65 then
				color = "yellow"
			else
				color = "green"
			end

			return { { string.format("󰋊 %s %s%% ", source, s.usage), color } }
		end
	end
end

local function entry(st, job)
	local cwd = job.args[1]
	local output = Command("timeout"):arg("1"):arg("df"):arg("--output=source,pcent"):arg(cwd):output()

	if not output or not output.status.success then
		set_state(cwd, "", nil)
		return
	end

	local source, usage = output.stdout:match(".*%s(%S+)%s+(%d+)%%")
	usage = tonumber(usage)

	if source == st.source and usage == st.usage and cwd == st.cwd then return end

	set_state(cwd, source, usage)
end

return { setup = setup, entry = entry }
