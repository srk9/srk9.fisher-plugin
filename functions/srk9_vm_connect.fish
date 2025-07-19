function srk9_vm_connect --description "Connect to and manage macOS VM instances"
    set -l vm_name ""
    set -l connection_type "screen"
    set -l vm_dir "$HOME/.srk9/vms"
    set -l help_flag false

    # Parse arguments
    for i in (seq (count $argv))
        switch $argv[$i]
            case -n --name
                if test (math $i + 1) -le (count $argv)
                    set vm_name $argv[(math $i + 1)]
                else
                    echo "Error: --name requires a value"
                    return 1
                end
            case -t --type
                if test (math $i + 1) -le (count $argv)
                    set connection_type $argv[(math $i + 1)]
                else
                    echo "Error: --type requires a value"
                    return 1
                end
            case --vm-dir
                if test (math $i + 1) -le (count $argv)
                    set vm_dir $argv[(math $i + 1)]
                else
                    echo "Error: --vm-dir requires a value"
                    return 1
                end
            case -h --help
                set help_flag true
        end
    end

    if test $help_flag = true
        _srk9_vm_connect_help
        return 0
    end

    if test -z "$vm_name"
        echo "Error: VM name is required"
        echo "Use: srk9_vm_connect --name YOUR_VM_NAME"
        return 1
    end

    set -l vm_path "$vm_dir/$vm_name"
    
    if not test -d $vm_path
        echo "Error: VM '$vm_name' not found at $vm_path"
        echo "Use 'srk9_create_macos_vm list' to see available VMs"
        return 1
    end

    # Check if VM is running
    if not pgrep -f "start.swift.*$vm_name" >/dev/null
        echo "VM '$vm_name' is not running"
        echo "Start it with: srk9_create_macos_vm start --name $vm_name"
        return 1
    end

    switch $connection_type
        case screen
            _srk9_vm_screen_share $vm_name
        case ssh
            _srk9_vm_ssh_connect $vm_name
        case info
            _srk9_vm_connection_info $vm_name
        case '*'
            echo "Unknown connection type: $connection_type"
            _srk9_vm_connect_help
            return 1
    end
end

function _srk9_vm_connect_help
    echo "SRK9 macOS VM Connection Manager"
    echo ""
    echo "USAGE:"
    echo "  srk9_vm_connect [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  -n, --name NAME           VM name (required)"
    echo "  -t, --type TYPE           Connection type: screen, ssh, info (default: screen)"
    echo "  --vm-dir DIR              Directory where VMs are stored"
    echo "  -h, --help                Show this help"
    echo ""
    echo "CONNECTION TYPES:"
    echo "  screen                    Connect via Screen Sharing (VNC)"
    echo "  ssh                       Connect via SSH (requires SSH setup in VM)"
    echo "  info                      Show connection information"
    echo ""
    echo "EXAMPLES:"
    echo "  # Connect via Screen Sharing"
    echo "  srk9_vm_connect --name test-vm"
    echo ""
    echo "  # Show connection info"
    echo "  srk9_vm_connect --name test-vm --type info"
    echo ""
    echo "  # Connect via SSH"
    echo "  srk9_vm_connect --name test-vm --type ssh"
end

function _srk9_vm_screen_share
    set -l vm_name $argv[1]
    
    echo "Connecting to VM '$vm_name' via Screen Sharing..."
    echo ""
    echo "🖥️  Opening Screen Sharing connection..."
    echo ""
    echo "If this is the first connection:"
    echo "1. You may see a black screen initially"
    echo "2. The VM may be at the macOS installer or login screen"
    echo "3. Follow the macOS setup wizard if it's a new installation"
    echo ""
    
    # Try to connect via Screen Sharing
    # The VM should be accessible on localhost with its assigned VNC port
    open vnc://localhost:5900
    
    if test $status -ne 0
        echo "Failed to open Screen Sharing"
        echo ""
        echo "Alternative connection methods:"
        echo "1. Open Screen Sharing manually: vnc://localhost:5900"
        echo "2. Use Finder -> Go -> Connect to Server -> vnc://localhost:5900"
        echo "3. Check VM status: srk9_create_macos_vm status --name $vm_name"
    else
        echo "✅ Screen Sharing connection initiated"
        echo ""
        echo "Connection Details:"
        echo "• Protocol: VNC"
        echo "• Address: localhost:5900"
        echo "• VM: $vm_name"
    end
end

function _srk9_vm_ssh_connect
    set -l vm_name $argv[1]
    
    echo "SSH connection to VM '$vm_name'..."
    echo ""
    echo "⚠️  SSH Requirements:"
    echo "1. VM must be fully booted into macOS"
    echo "2. SSH must be enabled in VM's System Preferences"
    echo "3. User account must be created in the VM"
    echo ""
    echo "To enable SSH in the VM:"
    echo "1. Connect via Screen Sharing first"
    echo "2. Go to System Preferences → Sharing"
    echo "3. Enable 'Remote Login'"
    echo "4. Note the VM's IP address"
    echo ""
    
    # Try to detect VM IP (this is simplified - real implementation would need VM tools)
    echo "Attempting to find VM IP address..."
    echo "VM IP detection requires VM to be fully configured"
    echo ""
    echo "Manual SSH connection:"
    echo "1. Find VM IP: ifconfig (run inside VM)"
    echo "2. SSH: ssh username@VM_IP_ADDRESS"
    echo ""
    echo "Use Screen Sharing to configure SSH first:"
    echo "srk9_vm_connect --name $vm_name --type screen"
end

function _srk9_vm_connection_info
    set -l vm_name $argv[1]
    
    echo "Connection Information for VM: $vm_name"
    echo "=" (string repeat -n (string length "Connection Information for VM: $vm_name") "=")
    echo ""
    
    echo "🖥️  Screen Sharing (VNC):"
    echo "   Address: vnc://localhost:5900"
    echo "   Status: Available (if VM is running)"
    echo "   Use: srk9_vm_connect --name $vm_name --type screen"
    echo ""
    
    echo "🌐 Network:"
    echo "   Type: NAT (shared with host)"
    echo "   VM gets its own IP in private range"
    echo "   Internet access: Available"
    echo ""
    
    echo "🔑 SSH Access:"
    echo "   Requires: SSH enabled in VM + user account"
    echo "   Setup: Use Screen Sharing to configure first"
    echo "   Use: srk9_vm_connect --name $vm_name --type ssh"
    echo ""
    
    echo "📁 File Sharing:"
    echo "   Method 1: Drag & drop in Screen Sharing"
    echo "   Method 2: Network file sharing (once configured)"
    echo "   Method 3: Cloud storage (iCloud, Dropbox, etc.)"
    echo ""
    
    echo "⚡ VM Controls:"
    echo "   Start: srk9_create_macos_vm start --name $vm_name"
    echo "   Stop: srk9_create_macos_vm stop --name $vm_name"
    echo "   Status: srk9_create_macos_vm status --name $vm_name"
    echo ""
    
    echo "🔧 First Boot Setup:"
    echo "1. Start VM: srk9_create_macos_vm start --name $vm_name"
    echo "2. Connect: srk9_vm_connect --name $vm_name"
    echo "3. Follow macOS installer prompts"
    echo "4. Create user account"
    echo "5. Enable SSH in System Preferences → Sharing"
    echo ""
    
    echo "💡 Tips:"
    echo "• VM has dedicated IP address for easy networking"
    echo "• Screen Sharing is most reliable for initial setup"
    echo "• VM automatically gets internet access"
    echo "• Press Ctrl+C in terminal to stop VM"
end