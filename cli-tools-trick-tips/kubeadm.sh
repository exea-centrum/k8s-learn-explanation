kubeadm
kubeadm is used for managing k8s clusters.

Full life-cycle:

kubeadm init: bootstrap the first node.
kubeadm join: bootstrap more nodes and join to the cluster.
kubeadm upgrade: upgrade a Kubernetes cluster to a newer version; perform the upgrade of etcd by default.
kubeadm reset: performs a best effort revert of changes made to this host by kubeadm init or kubeadm join.
NOT in scope:

provisioning machines: use metal3 for provisioning bare-metal machines.
installing addons, e.g. dashboard, monitoring solutions, and cloud-specific addons, etc.
Used by other tools like minikube, kind, etc.

Commands
Token
Create token

$ kubeadm token create
List token

$ kubeadm token list
Init
$ kubeadm init --control-plane-endpoint=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=$POD_CIDR --node-name $NODENAME --ignore-preflight-errors Swap

$ kubeadm init --pod-network-cidr=192.168.0.0/16
Join as a worker node
Print join command

$ kubeadm token create --print-join-command
# this will print something like this:
# kubeadm join 10.200.xxx.xxx:443 --token 0iyxxx.72o1s06xxxxxxx --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxxxx
Join:

$ kubeadm join --token TOKEN MASTER_IP:MASTER_PORT --discovery-token-ca-cert-hash sha256:HASH

$ kubeadm join phase control-plane-prepare certs --config /dev/stdin --v 5
Join as a control-plane node
--certificate-key string: When used together with '--print-join-command', print the full 'kubeadm join' flag needed to join the cluster as a control-plane. To create a new certificate key you must use 'kubeadm init phase upload-certs --upload-certs'.

Tear down a node
$ kubectl drain NODE --delete-local-data --force --ignore-daemonsets
$ kubectl delete node NODE
$ kubeadm reset
To force reset:

$ kubeadm reset --force
Config
Get Pod and Service CIDRs

$ kubeadm config view | grep Subnet
Dump config

$ cd /etc
$ kubeadm config view > kubeadmconf.yaml
Get kubeconfig

$ kubeadm kubeconfig user --client-name kubernetes-admin
Troubleshooting
Port 10250 is in use
kubeadm may throw error: Port 10250 is in use.

10250 is used by kubelet.

$ lsof -i:10250
COMMAND   PID USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
kubelet 68360 root   18u  IPv6  473103      0t0  TCP *:10250 (LISTEN)
Try to kill the existing kubelet.

What happends during kubeadm reset?
Use --dry-run. It prints the actions it will take.

$ kubeadm reset --dry-run
[reset] Reading configuration from the cluster...
[reset] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks
[reset] Would remove the etcd member on this node from the etcd cluster
[reset] Would delete contents of the etcd data directory: /var/lib/etcd
[reset] Would stop the kubelet service
[reset] Would unmount mounted directories in "/var/lib/kubelet"
[reset] Would remove Kubernetes-managed containers
[reset] Would delete contents of directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]
[reset] Would delete files: [/etc/kubernetes/admin.conf /etc/kubernetes/super-admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]

The reset process does not clean CNI configuration. To do so, you must remove /etc/cni/net.d

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually by using the "iptables" command.

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system's IPVS tables.

The reset process does not clean your kubeconfig files and you must remove them manually.
Please, check the contents of the $HOME/.kube/config file.