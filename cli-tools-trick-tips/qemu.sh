QEMU
QEMU (Quick EMUlator) is a free and open-source emulator and virtualizer. It can emulate a variety of CPU architectures (like x86, ARM, PowerPC, MIPS) and can run operating systems for one architecture on a machine of a different architecture (emulation). It can also achieve near-native performance by leveraging hardware virtualization extensions (like Intel VT-x or AMD-V) on x86 hosts through KVM (Kernel-based Virtual Machine).

Core Concepts
Emulator: Runs software for one architecture on another (e.g., ARM OS on x86 hardware). Slower.
Virtualizer: Runs software for the same architecture but provides an isolated environment. Faster, especially with KVM.
KVM (Kernel-based Virtual Machine): A Linux kernel module that allows a host machine to use hardware virtualization features. QEMU integrates with KVM to provide near-native performance for virtual machines.
Disk Image: A file that represents a virtual hard drive for the guest OS (e.g., .qcow2, .img).
BIOS/UEFI: Virtual firmware for the guest.
Networking Modes: User-mode networking (-nic user) for simple outbound access, or bridge/tap networking (-netdev tap) for more advanced scenarios.
Getting Started: Basic VM Launch
The most common way to use QEMU is to launch a virtual machine.

1. Launch a Linux VM from a Disk Image
Syntax:

qemu-system-x86_64 \
    -enable-kvm \
    -m <memory_in_mb> \
    -cpu host \
    -smp <num_cores>,cores=<num_cores> \
    -hda <disk_image_file> \
    -boot <order> \
    -vga virtio \
    -display sdl,gl=on # or gtk, vnc
Explanation:

qemu-system-x86_64: The QEMU executable for 64-bit x86 systems (replace with qemu-system-aarch64 for ARM, etc.).
-enable-kvm: Enable KVM hardware virtualization (crucial for performance on x86).
-m 2048: Allocate 2048 MB (2 GB) of RAM to the VM.
-cpu host: Tell QEMU to pass through the host CPU type, enabling features like VT-x/AMD-V.
-smp 4,cores=4: Configure 4 virtual CPUs, with 4 cores.
-hda my_linux_disk.qcow2: Attach my_linux_disk.qcow2 as the primary hard disk.
-boot once=c: Boot from the first hard disk (c). Use d for CD-ROM, n for network. once=c means boot from disk once, then follow default.
-vga virtio: Use the virtio GPU driver for better performance (requires virtio drivers in guest). Other options: std, qxl.
-display sdl,gl=on: Use SDL for display, enable OpenGL acceleration. Other options: gtk, vnc=:0 (for VNC server on port 5900).
Example:

qemu-system-x86_64 \
    -enable-kvm \
    -m 4096 \
    -cpu host \
    -smp 4,cores=2,threads=2 \
    -hda ubuntu.qcow2 \
    -cdrom ubuntu-22.04-desktop-amd64.iso \
    -boot d \
    -netdev user,id=mynet0 \
    -device virtio-net,netdev=mynet0 \
    -vga virtio \
    -display sdl,gl=on
(This example boots from an ISO to install, then you'd remove -cdrom and change -boot to c for subsequent boots).

Disk Image Management (qemu-img)
qemu-img is the utility for creating, converting, and managing QEMU disk images.

1. Create a New Disk Image
Purpose: Create an empty virtual hard disk.
Syntax:
qemu-img create -f <format> <filename> <size>
Examples:
qemu-img create -f qcow2 my_linux_disk.qcow2 20G # 20 GB QCOW2 image
qemu-img create -f raw my_raw_disk.img 10G # 10 GB RAW image
Formats:
qcow2: QEMU Copy On Write (recommended). Supports snapshots, smaller file sizes, less space allocated upfront.
raw: Direct image. Fastest, but no advanced features. Can be used as a loop device.
vmdk: VMware format.
vdi: VirtualBox format.
2. Convert a Disk Image
Purpose: Change the format of an existing disk image.
Syntax:
qemu-img convert -f <input_format> -O <output_format> <input_filename> <output_filename>
Example:
qemu-img convert -f raw -O qcow2 my_raw_disk.img my_qcow2_disk.qcow2
3. Resize a Disk Image
Purpose: Increase (or decrease, with caution) the size of a disk image.
Syntax:
qemu-img resize <filename> +<size_increment>
qemu-img resize <filename> <new_total_size>
Example:
qemu-img resize my_linux_disk.qcow2 +10G # Add 10 GB
qemu-img resize my_linux_disk.qcow2 50G # Set total size to 50 GB
Note: Resizing the image file itself doesn't automatically resize the partition inside the guest OS. You'll need to use tools like gparted or resize2fs within the guest.
4. Get Information About a Disk Image
Purpose: View details like format, virtual size, etc.
Syntax:
qemu-img info <filename>
Example:
qemu-img info my_linux_disk.qcow2
Networking Options
1. User-Mode Networking (NAT)
Purpose: Simple setup where the guest can access the host network and the internet, but the host cannot directly access the guest (unless port forwarding is configured).
Syntax:
-netdev user,id=mynet0 \
-device virtio-net,netdev=mynet0
With Port Forwarding (Host to Guest):
-netdev user,id=mynet0,hostfwd=tcp::2222-:22 \
-device virtio-net,netdev=mynet0
(Forwards host port 2222 to guest port 22 for SSH)
2. Bridge/Tap Networking (Advanced)
Purpose: Allows the guest to appear as a full participant on the host's local network, receiving its own IP address. Requires host-side configuration (bridge creation, tap device setup) and often root privileges.
Host Configuration (Example for br0 and tap0):
# Create a tap device
sudo ip tuntap add dev tap0 mode tap user $(whoami)
# Bring up the tap device
sudo ip link set tap0 up
# Add tap device to a bridge (assuming br0 exists and is connected to physical NIC)
sudo brctl addif br0 tap0
QEMU Syntax:
-netdev tap,id=mynet0,ifname=tap0,script=no,downscript=no \
-device virtio-net,netdev=mynet0
Note: The script=no,downscript=no means QEMU won't try to run helper scripts; you manage the tap device manually on the host.
Other Useful QEMU Options
ISO for Installation:

-cdrom /path/to/my.iso
Audio Output:

-audiodev alsa,id=snd0 -device AC97,audiodev=snd0 # For ALSA
# Or for PulseAudio
-audiodev pa,id=snd0 -device AC97,audiodev=snd0
USB Device Passthrough: (Requires specific host setup and device identification)

-usb -device usb-host,vendorid=<vendor_id>,productid=<product_id>
(Use lsusb on host to find IDs)

Shared Folder (Virtio-9p): (Requires 9p client in guest)

-virtfs local,path=/path/to/host/share,mount_tag=hostshare,security_model=passthrough,id=hostshare \
-device virtio-9p-pci,fsdev=hostshare,mount_tag=hostshare
Inside guest: sudo mount -t 9p -o trans=virtio hostshare /mnt/hostshare

Serial Console: (Useful for headless VMs or debugging)

-serial mon:stdio # Redirects serial to QEMU's standard I/O
Snapshotting (QCOW2 only):

Internal snapshot (save VM state to image):
# During runtime, press Ctrl+A, then c to enter QEMU monitor, then type:
savevm <snapshot_name>
Start from snapshot:
qemu-system-x86_64 -snapshot -hda my_linux_disk.qcow2
(Loads the default snapshot or the last saved state)
Apply specific snapshot:
qemu-system-x86_64 -loadvm <snapshot_name> -hda my_linux_disk.qcow2
Debugging/Monitor:

-monitor stdio: Open the QEMU monitor in the terminal.
-monitor telnet:127.0.0.1:1234,server,nowait: Open monitor via Telnet.
Inside monitor: info help (list commands), q (quit), stop (pause VM), cont (continue VM).
Ctrl+A, then c: Toggle between guest console and QEMU monitor.
Performance Tips
Always use KVM: -enable-kvm (on Linux hosts with VT-x/AMD-V).
Use Virtio drivers: -device virtio-blk, -device virtio-net, -vga virtio. These require virtio drivers within the guest OS.
Allocate enough RAM and CPU: -m, -smp.
-cpu host: Exposes host CPU features to the guest.
Modern disk format: qcow2 for features, but raw can be faster if no snapshots/COW needed.
QCOW
QCOW = QEMU Copy On Write.

qcow is a file format for disk image files used by QEMU.

Why qcow? It only takes up as much disk space as the guest OS actually uses.

Commands
# Show image info
$ qemu-img info disk.qcow2

# Convert an existing qcow2 image to new format
$ qemu-img amend -o compat=1.1 disk.qcow2

# Create a virtual disk
$ qemu-img create -f qcow2 myDisk.qcow2 20G
QCOW1 vs QCOW2 vs QCOW3
QCOW1 and QCOW2 have two completely different driver implementations and the two versions actually are exposed as two different image formats ("qcow" and "qcow2") to the user.
QCOW3 is strictly an extension of QCOW2, it keeps the fundamental structure unchanged. Internally, QEMU will have a single driver for both QCOW2 and QCOW3 images.
compat=1.1 means it is using the new QCOW3 format, though the file may still be named .qcow2.
Off the shelf
Debian 12: https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2