Cilium
Cilium is a network addon. Cilium can replace kube-proxy and iptables.

eBPF is used to safely and efficiently extend the capabilities of the kernel without requiring to change kernel source code or load kernel modules.

eBPF in kernel.
Cilium, pods are in user space.
Cilium installs eBPF programs; traffic between pods go through eBPF. The eBPF programs installed in the kernel decide how to route the packet. Unlike IPTables, eBPF programs have access to Kubernetes-specific metadata including network policy information.

CLI
(ds=daemonset, replace the name ds/cilium if your daemonset is not named cilium)

# Show all status
$ kubectl -n kube-system exec ds/cilium -- cilium status
$ kubectl -n kube-system exec ds/cilium -- cilium status --verbose

# Check if Cilium is replacing `kube-proxy`
$ kubectl -n kube-system exec ds/cilium -- cilium status | grep KubeProxyReplacement
# KubeProxyReplacement:    Partial

# Check if Cilium is using a KVStore; either `Disabled` or a list of etcd addresses
$ kubectl -n kube-system exec ds/cilium -- cilium status | grep KVStore

# Get cilium pods
$ kubectl -n kube-system get pods -l k8s-app=cilium
Cilium CLI is cilium in stable and older versions, but is cilium-dbg in the latest version.

A Cilium Deployment
A DaemonSet running cilium Pods; a ConfigMap for configs; ServiceAccount, ClusterRole, ClusterRoleBinding; a Secret to access the etcd.

Storage:

a central repository (kvstore, often etcd) that all Cilium agents will connect to.
Since Cilium 1.6: The addition of a new CRD-based backend for security identities now allows to operate Cilium entirely without a KVstore in the context of Kubernetes.
Cilium APIs
APIs:

cilium/v2::CiliumClusterwideNetworkPolicy
cilium/v2::CiliumEgressGatewayPolicy
cilium/v2::CiliumEndpoint
cilium/v2::CiliumNetworkPolicy
cilium/v2::CiliumNode
Related:

core/v1::Namespace
core/v1::Node
core/v1::Pods
core/v1::Service
discovery/v1::EndpointSlice
networking.k8s.io/v1::NetworkPolicy
CiliumNode
One CiliumNode for each Node. The Cilium operator will manage the per-node PodCIDRs via the CiliumNode's .spec.ipam.podCIDRs instead of the PodCIDRs found in Node. (Some CNI implementations do not respect Node.spec.podCIDR.)

CiliumEndpoint
One CiliumEndpoint is created for each Pod managed by Cilium, with the same name and in the same namespace.

Hubble
Hubble (https://github.com/cilium/hubble): for networking observability.

Hubble is a fully distributed networking and security observability platform for cloud native workloads. It is built on top of Cilium and eBPF to enable deep visibility into the communication and behavior of services as well as the networking infrastructure in a completely transparent manner.

Azure Advanced Network Observability extends the Hubble control plane beyond Cilium. In Cilium based clusters, Cilium provides the eBPF events to Hubble. In non-Cilium based clusters, Microsoft Retina serves as the dataplane surfacing deep insights to Hubble, providing a seamless interactive experience for customers.

Load Balancing
Metallb is the LoadBalancer for bare metal clusters (in contrast to AWS / GCP, etc) that works with Cilium.