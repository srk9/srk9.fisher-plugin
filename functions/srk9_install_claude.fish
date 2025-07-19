function srk9_install_claude --description "Install Claude CLI using Bun"
    echo "Installing Claude CLI..."
    echo "========================================================"
    
    # Check if Bun is available
    if not command -q bun
        echo "Error: Bun is not installed. Please run 'srk9_install_bun' first."
        return 1
    end
    
    # Install Claude CLI globally with Bun
    echo "Installing @anthropic-ai/claude-code with Bun..."
    bun install -g @anthropic-ai/claude-code
    
    if command -q claude
        echo "Claude CLI installed successfully!"
        echo "Claude version: "(claude --version)
    else
        echo "Installation completed, but 'claude' command not found in PATH."
        echo "You may need to restart your shell."
    end
    
    echo "========================================================"
    echo "To use Claude CLI, run: claude"
end