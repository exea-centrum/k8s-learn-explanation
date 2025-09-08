Kind CLI
# Create clusters.
$ kind create cluster --name test-cluster

# Get clusters.
$ kind get clusters
test-cluster

# Get nodes of a cluster.
$ kind get nodes --name test-cluster
test-cluster-control-plane

# Get kubeconfig and use it to talk to the cluster.
$ kind get kubeconfig --name test-cluster > ~/test-cluster-kubeconfig
$ kubectl --kubeconfig  ~/test-cluster-kubeconfig ...
$ k9s --kubeconfig  ~/test-cluster-kubeconfig

$ kind export kubeconfig --name test-cluster
Set kubectl context to "kind-test-cluster"
# `current-context` of `~/.kube/config` is updated to `kind-test-cluster`

# Export logs
$ kind export logs --name test-cluster
Exporting logs for cluster "test-cluster" to: /path/to/log

# load images; calls `ctr images import` under the hood.
$ kind load image-archive

# Get IP address
$ docker container inspect test-cluster-control-plane \
 --format '{{ .NetworkSettings.Networks.kind.IPAddress }}'

# Delete clusters.
$ kind delete cluster --name test-cluster

# Check kind version
$ kind version
Check inside the control plane node.

# Get the container name of the control plane.
$ docker ps
CONTAINER ID   IMAGE                  ... NAMES
2ff461dc6529   kindest/node:v1.xx.x   ... test-cluster-control-plane

# Get inside the container.
$ docker exec -it test-cluster-control-plane bash
# List images on the control plane node.
root@test-cluster-control-plane:/# crictl images
# List running containers.
root@test-cluster-control-plane:/# crictl ps
# List running processes
root@test-cluster-control-plane:/# ps aux
Notes about control plane processes:

built-in components as expected: kube-apiserver, kube-scheduler, kube-controller-manager, kube-proxy, etcd, coredns, etc
containerd as a CRI implementation to deal with Pods and containers. No docker inside the control plane docker container.
Networking
By default Kind clusters use a bridge network named kind (check by docker network ls). This can be overriden by setting KIND_EXPERIMENTAL_DOCKER_NETWORK.

$ KIND_EXPERIMENTAL_DOCKER_NETWORK=test-network kind create cluster --name test-cluster-with-test-network

# List networks
$ docker network ls
NETWORK ID     NAME           DRIVER    SCOPE
02ef0832c25e   test-network   bridge    local

# Check details of the network
$ docker network inspect test-network

# Clean up unused networks
$ docker network prune
The number of networks you can create is limited by /etc/docker/daemon.json. You may see this error:

Error response from daemon: could not find an available, non-overlapping IPv4 address pool among the defaults to assign to the network
https://github.com/kubernetes-sigs/kind/blob/3610f606516ccaa88aa098465d8c13af70937050/pkg/cluster/internal/providers/docker/provider.go#L73

How to create kind clusters with multiple nodes?
$ cat <<EOF | kind create cluster --name test-cluster-with-multiple-nodes --config -
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOF

$ kind get nodes --name test-cluster-with-multiple-nodes
test-cluster-with-multiple-nodes-worker
test-cluster-with-multiple-nodes-worker2
test-cluster-with-multiple-nodes-control-plane
How to Enable Shell Completion?
# bash
$ source <(kind completion bash)
$ echo "source <(kind completion bash)" >> ~/.bashrc

# zsh
$ source <(kind completion zsh)
# or
$ echo "source <(kind completion zsh)" >> ~/.zshrc
How to make packages available in kind
Option 1: kind load (without a registry)
Use kind load. This loads images without a registry. For example:

# Step 1: create the image
$ docker build -t my-custom-image:unique-tag ./my-image-dir

# Step 2: kind load the image
$ kind load docker-image my-custom-image:unique-tag

# Step 3: run
$ kubectl apply -f my-manifest-using-my-image:unique-tag
Under the hood: it uses LoadImageArchive() (https://github.com/kubernetes-sigs/kind/blob/main/pkg/cluster/nodeutils/util.go), which calls ctr images import internally.

To check:

Get name of a node by running kubectl get nodes.
Get into the node by running docker exec -ti <nodename> bash
From there run crictl images to see images loaded on that node.
or use

$ docker exec -it ${CLUSTER_NAME}-control-plane crictl images
or check the Node CR, available images will be shown in status.images

$ kubectl get nodes kind-control-plane -o yaml
Option 2: use a local docker registry
Follow the official dock: https://kind.sigs.k8s.io/docs/user/local-registry/

Essentially it

starts a docker registry by docker run registry:2.
connect the registry to the cluster network.
configure containerd to use the local registry.
Option 3: use a Harbor
Option 3.1: deploy Harbor on localhost
Option 3.2: deploy Harbor in the kind cluster
Troubleshooting
"too many open files"
Check limits:

$ sysctl fs.inotify.max_user_instances
fs.inotify.max_user_instances = 256

$ sysctl fs.inotify.max_user_watches
fs.inotify.max_user_watches = 4194304
To increase limits:

$ sudo sysctl fs.inotify.max_user_instances=1024
Under the hood
Kind depend on many other projects:

kind uses kubeadm to configure cluster nodes.
kind uses either Docker or Podman as the Provider.
Base Image vs Node Image
Base image: dependencies, but no k8s

OS (ubuntu), systemd, containerd, certificates, mount.
using a static Dockerfile: https://github.com/kubernetes-sigs/kind/blob/main/images/base/Dockerfile
Node image: base image + k8s (pkg/build/nodeimage/)

includes k8s tools like kubeadm, kubectl
runs kubelet
/kind/images/*.tar: docker image archves that will be loaded prior to running kubeadm
/kind/manifests/*.yaml
/kind/kubeadm.conf
dynamically build (instead of a Dockerfile) https://github.com/kubernetes-sigs/kind/blob/main/pkg/build/nodeimage/build.go
Providers
Providers: e.g. Docker or Podman. (https://github.com/kubernetes-sigs/kind/blob/main/pkg/cluster/internal/providers)

type Provider struct {
  provider internalproviders.Provider
  logger   log.Logger
}
Create a kind cluster with rootless docker

$ export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock
$ kind create cluster
When to use kind?
kind can be used for

creating a local Kubernetes cluster for development environments
creating a temporary bootstrap cluster used to provision a target management cluster on the selected infrastructure provider