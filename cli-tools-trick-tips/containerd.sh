Cheatsheet - containerd
Related:

crictl cheatsheets
crictl vs ctr
containerd - binary and logs
containerd is running as a systemd service.

# containerd service lifecycle
$ systemctl start containerd
$ systemctl stop containerd
$ systemctl restart containerd

# view containerd logs
$ journalctl -u containerd
containerd - config
Config file: /etc/containerd/config.toml

sandbox_image: pause-amd64 (you can overwrite the pause image)
default runtime, e.g. runc
registry auth/ca/mirrors
Registry
version = 2

[plugins."io.containerd.grpc.v1.cri".registry]
config_path = "/etc/containerd/certs.d"
Per registry config:

$ tree /etc/containerd/certs.d
/etc/containerd/certs.d
└── docker.io
    └── hosts.toml
Another way to check registry mirrors: crictl info.

ctr Commands
ctr separates tasks from containers:

containers: NOT processes, but isolated and restricted execution environments for processes.
tasks: the actual processes.
# Pull imagge
$ ctr image pull docker.io/library/hello-world:latest

# Start the container
$ ctr run docker.io/library/hello-world:latest CONTAINER_ID

# List running containers (in default namespace)
$ ctr container ls

# List running containers in k8s.io namespace
$ ctr --namespace k8s.io container ls

# Inspect a container
$ ctr container info CONTAINER_ID

# Delete a container
$ ctr container remove CONTAINER_ID

# ctr run = ctr container create + ctr task start
$ ctr container create docker.io/library/nginx:alpine nginx1
# Start the process in background
$ ctr task start --detach nginx1

# List tasks
$ ctr task ls

# Attach the task to see the stdout and stderr.
$ ctr task attach nginx1

# Kill a task
$ ctr task kill -s 9 nginx1

# Remove a task
$ ctr task rm nginx1
kind load uses "ctr", "--namespace=k8s.io", "images", "import", "--digests", "--snapshotter="+snapshotter, "-"

Why ctr container ls returns nothing
If you do not see your containers in ctr container ls, that is because containerd is namespaced, and ctr container ls returns containers in the default namespace. To see the Kubernetes-managed containers, you need to add --namespace=k8s.io or -n=k8s.io.

How to clean up and restart containerd
Use systemctl restart:

$ find /var/lib/containerd -type f | xargs rm -f
$ systemctl restart containerd
Or stop, clean up, then start:

$ systemctl stop containerd
$ rm -rf /var/lib/containerd/
$ systemctl daemon-reload
$ systemctl start containerd
Folders and Files
/var/lib/containerd: the default directory for containerd metadata, which stores persistent data like snapshots, content, metadata, and plugin data.
/run/containerd: the default directory for containerd states, which stores temporary data like sockets, PIDs, runtime state, mount points, and other plugin data.
/etc/containerd: configs.
Check number of sandboxes and containers
# check the number of pod sandboxes:
$ ls /var/lib/containerd/io.containerd.grpc.v1.cri/sandboxes/ | wc -l

# check the number of containers
$ ls /var/lib/containerd/io.containerd.grpc.v1.cri/containers/ | wc -l
overlay
Check /etc/systemd/system/containerd.service, it may look like this:

$ cat /etc/systemd/system/containerd.service
...
[Service]
ExecStartPre=-/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd
...
The =- in ExecStartPre means "if the file does not exist, it will not be read and no error or warning message is logged."

modprobe overlay enables the overlay kernel module, before starting containerd.

Check if overlay is loaded:

$ lsmod | grep overlay
overlay               139264  56

# or
$ cat /proc/modules  | grep overlay
overlay 139264 56 - Live 0xffffffffc0ae5000
Install containerd
Official guide: https://github.com/containerd/containerd/blob/main/docs/getting-started.md

Install runc: apt install runc
Install CNI: https://github.com/containernetworking/plugins/releases
Install containerd: https://github.com/containerd/containerd/releases