function srk9-setup --description "Interactive TUI for setting up development environment"
    # Colors
    set -l reset (set_color normal)
    set -l bold (set_color --bold)
    set -l dim (set_color brblack)
    set -l green (set_color green)
    set -l red (set_color red)
    set -l yellow (set_color yellow)
    set -l cyan (set_color cyan)

    # Tool definitions: name, install_function, check_command
    set -l tools \
        "bun:srk9-install-bun:bun" \
        "volta:srk9-install-volta:volta" \
        "rust:srk9-install-rust:cargo" \
        "python:srk9-install-python:pyenv" \
        "go:srk9-install-go:go" \
        "devbox:srk9-install-devbox:devbox" \
        "homebrew:srk9-install-homebrew-locally:brew" \
        "claude:srk9-install-claude:claude"

    function __srk9_check_installed --argument-names cmd
        command -q $cmd; and echo "installed"; or echo "not installed"
    end

    function __srk9_draw_header
        clear
        echo ""
        echo "  ╔═══════════════════════════════════════════════════════╗"
        echo "  ║           $argv[1]SRK9 Development Setup$argv[2]                  ║"
        echo "  ║           $argv[3]XDG Compliant • Sudo-Free$argv[2]               ║"
        echo "  ╚═══════════════════════════════════════════════════════╝"
        echo ""
    end

    # Initialize directories first
    if not set -q SRK9_OPT_DIR
        __srk9_draw_header $bold $reset $dim
        echo "  Initializing XDG directories..."
        srk9-init-dirs
        echo ""
        read -l -P "  Press Enter to continue..." _
    end

    # Main menu loop
    while true
        __srk9_draw_header $bold $reset $dim

        echo "  $bold STATUS $reset"
        echo "  ─────────────────────────────────────────────────────────"

        set -l idx 1
        for tool_def in $tools
            set -l parts (string split ":" $tool_def)
            set -l name $parts[1]
            set -l check_cmd $parts[3]

            set -l status (__srk9_check_installed $check_cmd)
            if test "$status" = "installed"
                set -l icon "$green✓$reset"
                set -l status_text "$green installed$reset"
            else
                set -l icon "$dim○$reset"
                set -l status_text "$dim not installed$reset"
            end

            printf "  %s %d. %-12s %s\n" $icon $idx $name $status_text
            set idx (math $idx + 1)
        end

        echo ""
        echo "  ─────────────────────────────────────────────────────────"
        echo "  $bold ACTIONS $reset"
        echo "   a) Install all missing tools"
        echo "   i) Install specific tool (enter number)"
        echo "   s) Show environment (srk9-env)"
        echo "   q) Quit"
        echo ""

        read -l -P "  Select option: " choice

        switch $choice
            case q Q
                echo ""
                echo "  $cyan Happy coding! $reset"
                echo ""
                return 0

            case a A
                __srk9_draw_header $bold $reset $dim
                echo "  $bold Installing all missing tools... $reset"
                echo ""

                for tool_def in $tools
                    set -l parts (string split ":" $tool_def)
                    set -l name $parts[1]
                    set -l install_fn $parts[2]
                    set -l check_cmd $parts[3]

                    if not command -q $check_cmd
                        echo "  ────────────────────────────────────────"
                        echo "  Installing $bold$name$reset..."
                        echo "  ────────────────────────────────────────"
                        $install_fn
                        echo ""
                    else
                        echo "  $green✓$reset $name already installed"
                    end
                end

                echo ""
                read -l -P "  Press Enter to continue..." _

            case i I
                read -l -P "  Enter tool number (1-8): " num

                if test -n "$num" -a "$num" -ge 1 -a "$num" -le 8 2>/dev/null
                    set -l tool_def $tools[$num]
                    set -l parts (string split ":" $tool_def)
                    set -l name $parts[1]
                    set -l install_fn $parts[2]

                    __srk9_draw_header $bold $reset $dim
                    echo "  Installing $bold$name$reset..."
                    echo ""
                    $install_fn
                    echo ""
                    read -l -P "  Press Enter to continue..." _
                else
                    echo "  $red Invalid selection $reset"
                    sleep 1
                end

            case s S
                __srk9_draw_header $bold $reset $dim
                srk9-env
                echo ""
                read -l -P "  Press Enter to continue..." _

            case 1 2 3 4 5 6 7 8
                set -l tool_def $tools[$choice]
                set -l parts (string split ":" $tool_def)
                set -l name $parts[1]
                set -l install_fn $parts[2]

                __srk9_draw_header $bold $reset $dim
                echo "  Installing $bold$name$reset..."
                echo ""
                $install_fn
                echo ""
                read -l -P "  Press Enter to continue..." _

            case '*'
                # Invalid input, just refresh
        end
    end
end
