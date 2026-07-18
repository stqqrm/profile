# config.fish

set -U fish_greeting
set -g fish_job_summary none
set -gx XDG_RUNTIME_DIR /run/user/(id -u)

function _sfg_draw
    set count (count $_sfg_ids)
    printf "\e[%dA" (math $count + 1)
    printf "\e[2K\e[1;34mJobs (up/down, Enter fg, Esc cancel)\e[0m\n"
    for i in (seq $count)
        if test $i -eq $_sfg_sel
            printf "\e[2K\e[1;32m [%s] %-30s \e[2m%s\e[0m\n" $_sfg_ids[$i] $_sfg_cmds[$i] $_sfg_states[$i]
        else
            printf "\e[2K\e[2m [%s] %-30s %s\e[0m\n" $_sfg_ids[$i] $_sfg_cmds[$i] $_sfg_states[$i]
        end
    end
end

function _sfg_cleanup
    set count (count $_sfg_ids)
    printf "\e[%dA" (math $count + 1)
    for i in (seq (math $count + 1))
        printf "\e[2K\n"
    end
    printf "\e[%dA" (math $count + 1)
    printf '\e[?25h'
    bind --erase up 2>/dev/null
    bind --erase down 2>/dev/null
    bind --erase pageup 2>/dev/null
    bind --erase pagedown 2>/dev/null
    bind --erase \n 2>/dev/null
    bind --erase \r 2>/dev/null
    bind --erase \e 2>/dev/null
    bind --erase q 2>/dev/null
    bind \cz smart_fg
    set -e _sfg_ids _sfg_cmds _sfg_states _sfg_sel
end

function _sfg_up
    if test $_sfg_sel -gt 1
        set -g _sfg_sel (math $_sfg_sel - 1)
    end
    _sfg_draw
end

function _sfg_down
    set count (count $_sfg_ids)
    if test $_sfg_sel -lt $count
        set -g _sfg_sel (math $_sfg_sel + 1)
    end
    _sfg_draw
end

function _sfg_confirm
    set id $_sfg_ids[$_sfg_sel]
    _sfg_cleanup
    fg %$id
    commandline -f repaint
end

function _sfg_cancel
    _sfg_cleanup
    commandline -f repaint
end

function smart_fg
    set job_count (jobs | count)

    if test $job_count -eq 0
        kill -TSTP (cat /proc/$(cat /proc/self/status | grep PPid | awk '{print $2}')/stat | awk '{print $6}') 2>/dev/null
        commandline -f repaint
        return
    else if test $job_count -eq 1
        set job_id (jobs | string match -r '^\s*(\d+)' | string trim)
        fg %$job_id
        commandline -f repaint
        return
    end

    set -g _sfg_ids
    set -g _sfg_cmds
    set -g _sfg_states

    jobs | while read -l line
        set parts (string match -r '^\s*(\d+)\s+\S+\s+\S+\s+(\S+)\s+(.+)' -- $line)
        if test (count $parts) -ge 4
            set -ga _sfg_ids $parts[2]
            set -ga _sfg_states $parts[3]
            set -ga _sfg_cmds $parts[4]
        end
    end

    if test (count $_sfg_ids) -eq 0
        commandline -f repaint
        return
    end

    set -g _sfg_sel 1

    bind up _sfg_up
    bind down _sfg_down
    bind pageup _sfg_up
    bind pagedown _sfg_down
    bind \n _sfg_confirm
    bind \r _sfg_confirm
    bind \e _sfg_cancel
    bind \cz _sfg_confirm
    bind q _sfg_cancel

    printf '\e[?25l'

    set count (count $_sfg_ids)
    for i in (seq (math $count + 1))
        printf "\n"
    end

    _sfg_draw
end

bind \cz smart_fg

# Fuzzy finder
fzf --fish | source

function _fzf_dir
	set -l query (commandline)
	set -l dir (find . -type d 2>/dev/null \
        | fzf -i --exact --query="$query" \
              --preview='ls {}' \
              --height=40% --reverse)
	if test -n "$dir"
		 cd $dir
		commandline -f repaint
	end
end

function _fzf_file
	set -l current (commandline)
    set -l file (find . -type f 2>/dev/null \
        | fzf -i --exact \
              --preview='cat {}' \
              --height=40% --reverse)
	if test -n "$file"
        # Strip leading ./
        set file (string replace -r '^\.' '' $file)
        commandline "$current $file"
    end
end

bind \cg _fzf_dir
bind \ct _fzf_file

function logout
	loginctl terminate-user $USER
end

function null
	$argv > /dev/null 2>&1 & disown
end

function _init
	if test -z "$TMUX" && not set -q NO_TMUX && test (id -u) -ne 0
		set session_name "$USER-$fish_pid"
		tmux new-session -d -s $session_name \; \
				new-window \; new-window \; new-window \; \
				new-window \; \
				select-window -t 1 \; \
				set-option -g destroy-unattached on \; \
				attach > /dev/null 2>&1
	end
end

if status is-interactive
	if status is-login; and not set -q WAYLAND_DISPLAY; and test (tty) = "/dev/tty1"
		
		set -l launch true 
		# put terminal in raw mode so any keypress is immediate
		stty -echo -icanon min 0 time 0 2>/dev/null
			
		for i in 3 2 1
			printf "\rLaunching labwc in %s... (press any key to cancel)" $i
			sleep 1
			# after sleeping, check if a byte is waiting
			if dd if=/dev/tty bs=1 count=1 2>/dev/null | string length -q
				set launch false
				break
			end
		end
			
		stty echo icanon 2>/dev/null
		echo
		if test "$launch" = true
			labwc
		end
	end

	if not set -q _bool_init
		set -g _bool_init 1
		_init
	end
end

function fish_prompt
	set_color yellow
	echo -n $USER

	set_color normal
	echo -n '@'

	set_color green
	echo -n (uname -n)

	set_color normal
	echo -n ' '

	if test (pwd) = $HOME
		set_color yellow
		echo -n '~'
	else
		set_color yellow
		echo -n '$'
	end

	set_color normal
	echo -n ' '
end
