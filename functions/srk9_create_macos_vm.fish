function srk9_create_macos_vm --description "Create and manage macOS virtual machines using Apple's Virtualization framework"
    set -l vm_name ""
    set -l vm_memory "8"
    set -l vm_disk_size "80"
    set -l vm_dir "$HOME/.srk9/vms"
    set -l installer_path ""
    set -l action "create"
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
            case -m --memory
                if test (math $i + 1) -le (count $argv)
                    set vm_memory $argv[(math $i + 1)]
                else
                    echo "Error: --memory requires a value"
                    return 1
                end
            case -d --disk-size
                if test (math $i + 1) -le (count $argv)
                    set vm_disk_size $argv[(math $i + 1)]
                else
                    echo "Error: --disk-size requires a value"
                    return 1
                end
            case -i --installer
                if test (math $i + 1) -le (count $argv)
                    set installer_path $argv[(math $i + 1)]
                else
                    echo "Error: --installer requires a value"
                    return 1
                end
            case --vm-dir
                if test (math $i + 1) -le (count $argv)
                    set vm_dir $argv[(math $i + 1)]
                else
                    echo "Error: --vm-dir requires a value"
                    return 1
                end
            case start
                set action "start"
            case stop
                set action "stop"
            case status
                set action "status"
            case list
                set action "list"
            case delete
                set action "delete"
            case -h --help
                set help_flag true
        end
    end

    if test $help_flag = true
        _srk9_vm_help
        return 0
    end

    # Create VM directory if it doesn't exist
    if not test -d $vm_dir
        mkdir -p $vm_dir
        echo "Created VM directory: $vm_dir"
    end

    switch $action
        case create
            _srk9_vm_create $vm_name $vm_memory $vm_disk_size $vm_dir $installer_path
        case start
            _srk9_vm_start $vm_name $vm_dir
        case stop
            _srk9_vm_stop $vm_name $vm_dir
        case status
            _srk9_vm_status $vm_name $vm_dir
        case list
            _srk9_vm_list $vm_dir
        case delete
            _srk9_vm_delete $vm_name $vm_dir
        case '*'
            echo "Unknown action: $action"
            _srk9_vm_help
            return 1
    end
end

function _srk9_vm_help
    echo "SRK9 macOS VM Manager"
    echo ""
    echo "USAGE:"
    echo "  srk9_create_macos_vm [OPTIONS] [ACTION]"
    echo ""
    echo "ACTIONS:"
    echo "  create                    Create a new macOS VM (default)"
    echo "  start                     Start an existing VM"
    echo "  stop                      Stop a running VM"
    echo "  status                    Show VM status"
    echo "  list                      List all VMs"
    echo "  delete                    Delete a VM"
    echo ""
    echo "OPTIONS:"
    echo "  -n, --name NAME           VM name (required for most actions)"
    echo "  -m, --memory GB           Memory in GB (default: 8)"
    echo "  -d, --disk-size GB        Disk size in GB (default: 80)"
    echo "  -i, --installer PATH      Path to macOS installer app"
    echo "  --vm-dir DIR              Directory to store VMs (default: ~/.srk9/vms)"
    echo "  -h, --help                Show this help"
    echo ""
    echo "EXAMPLES:"
    echo "  # Create a new VM with default settings"
    echo "  srk9_create_macos_vm --name test-vm"
    echo ""
    echo "  # Create VM with custom specs"
    echo "  srk9_create_macos_vm --name dev-vm --memory 16 --disk-size 120"
    echo ""
    echo "  # Start a VM"
    echo "  srk9_create_macos_vm start --name test-vm"
    echo ""
    echo "  # List all VMs"
    echo "  srk9_create_macos_vm list"
end

function _srk9_vm_create
    set -l vm_name $argv[1]
    set -l vm_memory $argv[2]
    set -l vm_disk_size $argv[3]
    set -l vm_dir $argv[4]
    set -l installer_path $argv[5]

    if test -z "$vm_name"
        echo "Error: VM name is required for creation"
        echo "Use: srk9_create_macos_vm --name YOUR_VM_NAME"
        return 1
    end

    set -l vm_path "$vm_dir/$vm_name"
    
    if test -d $vm_path
        echo "Error: VM '$vm_name' already exists at $vm_path"
        return 1
    end

    echo "Creating macOS VM: $vm_name"
    echo "Memory: ${vm_memory}GB"
    echo "Disk: ${vm_disk_size}GB"
    echo "Location: $vm_path"
    echo ""

    # Create VM directory
    mkdir -p $vm_path

    # Create disk image
    echo "Creating disk image..."
    hdiutil create -size "${vm_disk_size}g" -fs HFS+J -volname "macOS" "$vm_path/disk.dmg"
    
    if test $status -ne 0
        echo "Error: Failed to create disk image"
        rm -rf $vm_path
        return 1
    end

    # Create VM configuration file
    echo "Creating VM configuration..."
    cat > "$vm_path/config.json" << EOF
{
    "name": "$vm_name",
    "memory": $vm_memory,
    "disk_size": $vm_disk_size,
    "disk_path": "$vm_path/disk.dmg",
    "created": "$(date -Iseconds)"
}
EOF

    # Create startup script
    cat > "$vm_path/start.swift" << 'EOF'
import Foundation
import Virtualization

class VMDelegate: NSObject, VZVirtualMachineDelegate {
    func virtualMachine(_ virtualMachine: VZVirtualMachine, didStopWithError error: Error) {
        print("VM stopped with error: \(error)")
        exit(1)
    }
    
    func guestDidStop(_ virtualMachine: VZVirtualMachine) {
        print("VM stopped")
        exit(0)
    }
}

// Read config
let configPath = CommandLine.arguments[1]
let configData = try Data(contentsOf: URL(fileURLWithPath: configPath))
let config = try JSONSerialization.jsonObject(with: configData) as! [String: Any]

let vmConfig = VZVirtualMachineConfiguration()

// CPU configuration
vmConfig.cpuCount = ProcessInfo.processInfo.processorCount
if vmConfig.cpuCount > VZVirtualMachineConfiguration.maximumAllowedCPUCount {
    vmConfig.cpuCount = VZVirtualMachineConfiguration.maximumAllowedCPUCount
}

// Memory configuration  
let memoryGB = config["memory"] as! Int
vmConfig.memorySize = UInt64(memoryGB * 1024 * 1024 * 1024)

// Platform configuration
let platform = VZMacPlatformConfiguration()
let auxiliaryStorage = VZMacAuxiliaryStorage(contentsOf: URL(fileURLWithPath: "\(configPath.replacingOccurrences(of: "/config.json", with: ""))/auxiliary.storage"))
platform.auxiliaryStorage = auxiliaryStorage

if #available(macOS 13.0, *) {
    platform.hardwareModel = VZMacHardwareModel.default
    platform.machineIdentifier = VZMacMachineIdentifier()
} else {
    print("Error: macOS 13.0 or later required")
    exit(1)
}

vmConfig.platform = platform

// Boot loader
let bootLoader = VZMacOSBootLoader()
vmConfig.bootLoader = bootLoader

// Graphics
let graphics = VZMacGraphicsDeviceConfiguration()
graphics.displays = [VZMacGraphicsDisplayConfiguration(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)]
vmConfig.graphicsDevices = [graphics]

// Storage
let diskPath = config["disk_path"] as! String
let diskURL = URL(fileURLWithPath: diskPath)
let diskAttachment = try VZDiskImageStorageDeviceAttachment(url: diskURL, readOnly: false)
let storage = VZVirtIOBlockDeviceConfiguration(attachment: diskAttachment)
vmConfig.storageDevices = [storage]

// Networking
let networkDevice = VZVirtIONetworkDeviceConfiguration()
networkDevice.attachment = VZNATNetworkDeviceAttachment()
vmConfig.networkDevices = [networkDevice]

// Audio
let audioConfiguration = VZVirtIOSoundDeviceConfiguration()
audioConfiguration.streams = [
    VZVirtIOSoundDeviceInputStreamConfiguration(),
    VZVirtIOSoundDeviceOutputStreamConfiguration()
]
vmConfig.audioDevices = [audioConfiguration]

// Keyboard and pointing
vmConfig.keyboards = [VZUSBKeyboardConfiguration()]
vmConfig.pointingDevices = [VZUSBScreenCoordinatePointingDeviceConfiguration()]

// Validate configuration
try vmConfig.validate()

// Create and start VM
let vm = VZVirtualMachine(configuration: vmConfig)
let delegate = VMDelegate()
vm.delegate = delegate

print("Starting macOS VM: \(config["name"] as! String)")
print("Connect via Screen Sharing to localhost or use VM window")
print("Press Ctrl+C to stop the VM")

vm.start { result in
    switch result {
    case .success:
        print("VM started successfully")
    case .failure(let error):
        print("Failed to start VM: \(error)")
        exit(1)
    }
}

// Keep running
RunLoop.main.run()
EOF

    # Create auxiliary storage for the platform
    echo "Setting up auxiliary storage..."
    touch "$vm_path/auxiliary.storage"

    echo ""
    echo "✅ VM '$vm_name' created successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Download macOS installer from App Store or Apple Developer"
    echo "2. Start the VM: srk9_create_macos_vm start --name $vm_name"
    echo "3. During first boot, you'll be prompted to install macOS"
    echo "4. Connect via Screen Sharing or use the VM window"
    echo ""
    echo "VM location: $vm_path"
end

function _srk9_vm_start
    set -l vm_name $argv[1]
    set -l vm_dir $argv[2]

    if test -z "$vm_name"
        echo "Error: VM name is required"
        echo "Use: srk9_create_macos_vm start --name YOUR_VM_NAME"
        return 1
    end

    set -l vm_path "$vm_dir/$vm_name"
    
    if not test -d $vm_path
        echo "Error: VM '$vm_name' not found at $vm_path"
        echo "Use 'srk9_create_macos_vm list' to see available VMs"
        return 1
    end

    echo "Starting VM: $vm_name"
    echo "VM path: $vm_path"
    echo ""
    
    # Compile and run the Swift VM starter
    cd $vm_path
    swift start.swift config.json
end

function _srk9_vm_stop
    set -l vm_name $argv[1]
    set -l vm_dir $argv[2]

    if test -z "$vm_name"
        echo "Error: VM name is required"
        return 1
    end

    echo "Stopping VM: $vm_name"
    # Find and terminate VM processes
    pkill -f "start.swift.*$vm_name" 2>/dev/null
    echo "VM stop signal sent"
end

function _srk9_vm_status
    set -l vm_name $argv[1] 
    set -l vm_dir $argv[2]

    if test -z "$vm_name"
        echo "Error: VM name is required"
        return 1
    end

    set -l vm_path "$vm_dir/$vm_name"
    
    if not test -d $vm_path
        echo "VM '$vm_name' not found"
        return 1
    end

    echo "VM: $vm_name"
    echo "Path: $vm_path"
    
    if test -f "$vm_path/config.json"
        echo "Configuration: ✅"
        # Parse and display config details
        python3 -c "
import json
with open('$vm_path/config.json') as f:
    config = json.load(f)
    print(f'Memory: {config[\"memory\"]}GB')
    print(f'Disk: {config[\"disk_size\"]}GB')
    print(f'Created: {config[\"created\"]}')
"
    else
        echo "Configuration: ❌ Missing"
    end

    # Check if VM is running
    if pgrep -f "start.swift.*$vm_name" >/dev/null
        echo "Status: 🟢 Running"
    else
        echo "Status: 🔴 Stopped"
    end
end

function _srk9_vm_list
    set -l vm_dir $argv[1]

    if not test -d $vm_dir
        echo "No VMs directory found at: $vm_dir"
        return 0
    end

    echo "SRK9 macOS Virtual Machines"
    echo "Location: $vm_dir"
    echo ""

    set -l vm_count 0
    for vm_path in $vm_dir/*
        if test -d $vm_path
            set vm_count (math $vm_count + 1)
            set -l vm_name (basename $vm_path)
            
            printf "%-20s" $vm_name
            
            if pgrep -f "start.swift.*$vm_name" >/dev/null
                printf "🟢 Running    "
            else
                printf "🔴 Stopped    "
            end

            if test -f "$vm_path/config.json"
                python3 -c "
import json
try:
    with open('$vm_path/config.json') as f:
        config = json.load(f)
        print(f'{config[\"memory\"]}GB RAM, {config[\"disk_size\"]}GB disk')
except:
    print('Config error')
"
            else
                echo "No config"
            end
        end
    end

    if test $vm_count -eq 0
        echo "No VMs found"
        echo ""
        echo "Create one with: srk9_create_macos_vm --name YOUR_VM_NAME"
    else
        echo ""
        echo "Total VMs: $vm_count"
    end
end

function _srk9_vm_delete
    set -l vm_name $argv[1]
    set -l vm_dir $argv[2]

    if test -z "$vm_name"
        echo "Error: VM name is required"
        return 1
    end

    set -l vm_path "$vm_dir/$vm_name"
    
    if not test -d $vm_path
        echo "Error: VM '$vm_name' not found"
        return 1
    end

    # Stop VM if running
    if pgrep -f "start.swift.*$vm_name" >/dev/null
        echo "Stopping running VM..."
        _srk9_vm_stop $vm_name $vm_dir
        sleep 2
    end

    echo "⚠️  This will permanently delete VM '$vm_name' and all its data!"
    echo "VM path: $vm_path"
    read -P "Type 'DELETE' to confirm: " -l confirmation

    if test "$confirmation" = "DELETE"
        echo "Deleting VM..."
        rm -rf $vm_path
        echo "✅ VM '$vm_name' deleted successfully"
    else
        echo "❌ Deletion cancelled"
        return 1
    end
end