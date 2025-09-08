Cheatsheet - crictl
Warning: If you use crictl to create pod sandboxes or containers on a running Kubernetes cluster, the kubelet will eventually delete them. crictl is not a general purpose workflow tool, but a tool that is useful for debugging.

Pods
The biggest difference between crictl and docker is that crictl is aware of Pods.

# list pods
$ crictl pods

# by name
$ crictl pods --name POD_NAME

# get pod details
$ crictl pods --name POD_NAME -o yaml
$ crictl pods --name POD_NAME -o json

# list pods by label
$ crictl pods --label component=kube-apiserver

# get the latest pod
$ crictl pods --latest

# count Ready pods
$ crictl pods -state Ready | wc -l

# stop all the pods
$ crictl stopp $(crictl pods -q)

# delete all the pods
$ crictl rmp $(crictl pods -q)
npd (node-problem-detector) uses crictl pods --latest to determine if containerd is healthy. If not, npd will constantly restart it.

Images
# list images
$ crictl images

# list image id (sha256)
$ crictl images -q
sha256:8b8e4416e03730191ab808b229fbddf269dad641360ba583239a051cb01f99ed
sha256:248e85ba70e76d8ee617bcbd6061e9edd4e02e1f519e48cd2731c0dbbcc44b81

# pull image
$ crictl pull busybox

# remove image
$ crictl rmi IMAGE_ID

# remove unused images 
$ crictl rmi --prune
Containers
# list all containers (including Running and Exited)
$ crictl ps --all

# stop and remove all containers; `-t 0` = do not wait
$ crictl stop -t 0 $(crictl ps -aq)
$ crictl rm $(crictl ps -aq)

# remove all
$ crictl rm -a
Get inside the container:

# list files
$ crictl exec -i -t 1f73f2d81bf98 ls

# open an interactive shell
$ crictl exec -it 1f73f2d81bf98 sh
Get container log:

# find the container
$ crictl ps -a | grep foo

# get logs
$ crictl logs 87d3992f84f74

# follow the logs
$ crictl logs -f 87d3992f84f74

# get last lines
$ crictl logs --tail=1 87d3992f84f74
Print information about specific containers

$ crictl inspect 87d3992f84f74
How to check or set runtime endpoint?
crictl is the client, the container runtime is the server. To check the which server is crictl talking to, check runtime-endpoint in the config:

$ cat /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
To set the runtime endpoint, there are 2 ways:

Set the --runtime-endpoint and --image-endpoint flags.
Set the CONTAINER_RUNTIME_ENDPOINT and IMAGE_SERVICE_ENDPOINT environment variables.
How to find and kill NotReady Pods
kubelet maintains a GC mechanism that scans for dead pods and remove them. The GC mechanism runs every 1m. It calls containerd (essentially like crictli pods) to get a list of pods that are currently running and issue delete commands.

If during the short time period, there are a lot of pods come and go, the pod sandboxes are kept until the next GC kicked in.

If you see errors like this, maybe there are too many Pods (possibily many stuck NotReady pods), so when it tries to get a list of Pods (ListAllSandboxes), the size exceeds the grpc limit (in this case 16 MB).

"GenericPLEG: Unable to retrieve pods" err="rpc error: code = ResourceExhausted desc = grpc: trying to send message larger than max (16794825 vs. 16777216)"
If kubelet finds containerd not healthy, it will restart containerd; if kubelet keeps restarting containerd, npd will report a FrequentContainerdRestart condition.

crictl rmp can be used to delete Pod; a few ways to delete NotReady pods:

$ crictl rmp $(crictl pods -q --s NotReady)
$ crictl pods -state NotReady -o json | jq -r '.items[].id' | xargs -I% crictl rmp %
$ crictl pods | grep NotReady | cut -f1 -d" " | xargs -L 1 -I {} -t crictl rmp {}
# truncate name and count occurance
$ crictl pods -state NotReady -o json | jq -r '.items[].metadata.name' | cut -c1-20 | sort | uniq -c | sort
If you see the following error, containerd may be busy, stop creating new Pods first (e.g. scale down the deployments that may create new pods down to 0)

"RemovePodSandbox from runtime service failed" err="rpc error: code = DeadlineExceeded desc = context deadline exceeded" podSandboxID="xxxxxxxx"
Why crictl runp and create are discouraged?
Users should not run crictl runp or crictl create on a Kubernetes node directly. They are used for some special debug case. kubelet may eventually stop and delete the sandbox since there's no corresponding pod on apiserver.