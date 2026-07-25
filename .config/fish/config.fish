source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Added by LM Studio CLI (lms)
#set -gx PATH $PATH /home/sebastian/.lmstudio/bin
# End of LM Studio CLI section

#Zellij
if status is-interactive
    set -x ZELLIJ_AUTO_ATTACH true # attach to an existing session instead of always creating a new one
    set -x ZELLIJ_AUTO_EXIT true # close terminal when exitting zellij
    eval (zellij setup --generate-auto-start fish | string collect)
end

#Yazi
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	command rm -f -- "$tmp"
end
