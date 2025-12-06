function srk9-setup --description "Interactive TUI for setting up development environment"
    # Check for whiptail or dialog
    set -l dialog_cmd ""
    if command -q whiptail
        set dialog_cmd whiptail
    else if command -q dialog
        set dialog_cmd dialog
    else
        echo "This setup requires 'whiptail' or 'dialog' for the TUI."
        echo ""
        echo "Install with:"
        echo "  macOS:  brew install newt    # provides whiptail"
        echo "  Debian: apt install whiptail"
        echo "  Fedora: dnf install newt"
        echo ""
        echo "Or run individual installers directly:"
        echo "  srk9-install-bun"
        echo "  srk9-install-volta"
        echo "  etc."
        return 1
    end

    # Tool definitions: name|description|install_function|check_command
    set -l tools \
        "bun|JavaScript runtime & toolkit|srk9-install-bun|bun" \
        "volta|Node.js version manager|srk9-install-volta|volta" \
        "rust|Rust programming language|srk9-install-rust|cargo" \
        "python|Python via pyenv|srk9-install-python|pyenv" \
        "go|Go programming language|srk9-install-go|go" \
        "devbox|Nix-based dev environments|srk9-install-devbox|devbox" \
        "homebrew|Package manager (local)|srk9-install-homebrew-locally|brew" \
        "claude|Claude CLI assistant|srk9-install-claude|claude"

    # Initialize directories if needed
    if not set -q SRK9_OPT_DIR
        srk9-init-dirs >/dev/null 2>&1
    end

    # Main menu loop
    while true
        # Build menu items with status
        set -l menu_items
        set -l idx 1
        for tool_def in $tools
            set -l parts (string split "|" $tool_def)
            set -l name $parts[1]
            set -l desc $parts[2]
            set -l check_cmd $parts[4]

            if command -q $check_cmd
                set -a menu_items "$idx" "[$name] $desc ✓"
            else
                set -a menu_items "$idx" "[$name] $desc"
            end
            set idx (math $idx + 1)
        end

        # Add action items
        set -a menu_items "A" "Install ALL missing tools"
        set -a menu_items "S" "Show environment status"
        set -a menu_items "Q" "Quit"

        # Show main menu
        set -l choice ($dialog_cmd \
            --title "SRK9 Development Setup" \
            --backtitle "XDG Compliant • Sudo-Free • Local Install" \
            --menu "Select a tool to install or action to perform:\n\n✓ = already installed" \
            20 60 12 \
            $menu_items \
            3>&1 1>&2 2>&3)

        # Handle cancel/escape
        if test $status -ne 0
            clear
            echo "Setup cancelled."
            return 0
        end

        switch $choice
            case Q q
                clear
                echo ""
                echo "Happy coding!"
                echo ""
                return 0

            case S s
                clear
                srk9-env
                echo ""
                read -l -P "Press Enter to continue..." _

            case A a
                clear
                echo "════════════════════════════════════════════════════════"
                echo "  Installing all missing tools..."
                echo "════════════════════════════════════════════════════════"
                echo ""

                for tool_def in $tools
                    set -l parts (string split "|" $tool_def)
                    set -l name $parts[1]
                    set -l install_fn $parts[3]
                    set -l check_cmd $parts[4]

                    if not command -q $check_cmd
                        echo "────────────────────────────────────────────────────────"
                        echo "  Installing $name..."
                        echo "────────────────────────────────────────────────────────"
                        $install_fn
                        echo ""
                    else
                        echo "✓ $name already installed"
                    end
                end

                echo ""
                echo "════════════════════════════════════════════════════════"
                echo "  Installation complete!"
                echo "════════════════════════════════════════════════════════"
                read -l -P "Press Enter to continue..." _

            case '*'
                # Numeric selection
                if test "$choice" -ge 1 -a "$choice" -le 8 2>/dev/null
                    set -l tool_def $tools[$choice]
                    set -l parts (string split "|" $tool_def)
                    set -l name $parts[1]
                    set -l install_fn $parts[3]
                    set -l check_cmd $parts[4]

                    if command -q $check_cmd
                        # Already installed - offer info
                        $dialog_cmd \
                            --title "$name" \
                            --msgbox "$name is already installed.\n\nLocation: "(command -v $check_cmd) \
                            10 50
                    else
                        # Confirm installation
                        if $dialog_cmd \
                            --title "Install $name" \
                            --yesno "Install $name?\n\nThis will install to \$SRK9_OPT_DIR" \
                            10 50

                            clear
                            echo "════════════════════════════════════════════════════════"
                            echo "  Installing $name..."
                            echo "════════════════════════════════════════════════════════"
                            echo ""
                            $install_fn
                            echo ""
                            read -l -P "Press Enter to continue..." _
                        end
                    end
                end
        end
    end
end
