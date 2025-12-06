function srk9-install-rosetta --description "Install Rosetta 2 (Apple Silicon) - with deviation documentation"
    echo "========================================================"
    echo "Rosetta 2 Installation"
    echo "========================================================"
    echo ""
    echo "DEVIATION: Rosetta requires elevated privileges"
    echo "--------------------------------------------"
    echo "What:       Rosetta installation requires admin/sudo"
    echo "Why:        Apple system requirement for x86 emulation layer"
    echo "Impact:     Cannot install Rosetta without sudo"
    echo "Future Fix: Document as manual prerequisite; detect and prompt"
    echo ""
    echo "See: SPEC.md for full deviation documentation"
    echo "========================================================"
    echo ""

    # Check if on Apple Silicon
    if test (uname -m) != "arm64"
        echo "Rosetta is only needed on Apple Silicon Macs."
        echo "This appears to be an Intel Mac - skipping."
        return 0
    end

    # Check if already installed
    if test -f /Library/Apple/usr/share/rosetta/rosetta
        echo "✓ Rosetta 2 is already installed."
        return 0
    end

    echo "This will install Rosetta 2 for x86 compatibility."
    echo "Note: This requires sudo (admin privileges)."
    echo ""

    read -l -P "Continue with installation? [y/N] " confirm
    if test "$confirm" = "y" -o "$confirm" = "Y"
        echo ""
        echo "Installing Rosetta 2..."
        softwareupdate --install-rosetta --agree-to-license

        if test $status -eq 0
            echo ""
            echo "✓ Rosetta 2 installed successfully."
        else
            echo ""
            echo "✗ Installation failed. You may need to run manually:"
            echo "  sudo softwareupdate --install-rosetta --agree-to-license"
        end
    else
        echo "Installation cancelled."
        echo ""
        echo "To install manually:"
        echo "  sudo softwareupdate --install-rosetta --agree-to-license"
    end
end
