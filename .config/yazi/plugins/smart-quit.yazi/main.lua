return {
    entry = function()
        if os.getenv("YAZI_SCRIPT_MODE") == "1" then
            ya.emit("quit", {})
        else
            ya.notify({ title = "smart-quit", content = "normal mode branch hit", timeout = 3 })
            ya.emit("plugin", { "autosession", "save-and-quit" })
        end
    end
}
