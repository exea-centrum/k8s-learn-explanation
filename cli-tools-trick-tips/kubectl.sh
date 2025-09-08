Cheatsheet - kubectl
Working with Pods
How to force restart a pod
$ kubectl get pod PODNAME -n NAMESPACE -o yaml | kubectl replace --force -f -
How to get a list of pending pods
$ kubectl get pods --field-selector=status.phase=Pending
How to Delete multiple pods?
Delete multiple pods by label:

$ kubectl delete pods -l app=my-app -n default
Delete multiple pods by name:

$ kubectl get pods -n $NAMESPACE --no-headers=true | awk '/pattern/{print $1}'| xargs  kubectl delete -n $NAMESPACE pod
$ kubectl get pods -n $NAMESPACE | grep $PATTERN | awk '{print $2}' | xargs kubectl delete pod -n $NAMESPACE
Delete all completed / failed pods

$ kubectl --kubeconfig KUBECONFIG delete pods -A --field-selector status.phase=Succeeded
$ kubectl --kubeconfig KUBECONFIG delete pods -A --field-selector status.phase=Failed
Force delete all pods in a namespace:

$ kubectl delete pod --all --grace-period=0 --force --namespace foo-system
Force delete all terminating pods

$ kubectl get pods -A | grep Terminating | awk '{print $2 " -n=" $1}' | xargs kubectl delete pod --grace-period=0 --force
How to restrict pods to only run on the control-plane nodes?
$ kubectl patch -n kubevirt kubevirt kubevirt --type merge --patch '{"spec": {"infra": {"nodePlacement": {"nodeSelector": {"node-role.kubernetes.io/control-plane": ""}}}}}'
To restrict the virt-handler pods to only run on nodes with the region=primary label:

$ kubectl patch -n kubevirt kubevirt kubevirt --type merge --patch '{"spec": {"workloads": {"nodePlacement": {"nodeSelector": {"region": "primary"}}}}}'
Clusters
# Get Clusters.
$ kubectl config get-clusters

# Get Cluster Info
$ kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:36397
CoreDNS is running at https://127.0.0.1:36397/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

$ kubectl cluster-info dump
Specify output columns
$ kubectl get services -A -o=custom-columns=NAME:.metadata.name,Namespace:.metadata.namespace
API Resources
To see which Kubernetes resources are and aren't in a namespace:

# In a namespace
$ kubectl api-resources --namespaced=true

# Not in a namespace
$ kubectl api-resources --namespaced=false
Check resources

# Get a list of Services:
$ kubectl get services

# Check the service accounts:
$ kubectl -n kube-system get sa

# Get pods on a specific node.
$ kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=$NODE

# Get num of running pods.
$ kubectl get pods -A --field-selector status.phase=Running | wc -l
If there are multiple resources with the same name (e.g. Cluster), add the apigroup to it:

$ kubectl get clusters.cluster.x-k8s.io
How to list all resources in a namespace
$ kubectl api-resources --verbs=list --namespaced -o name  | xargs -n 1 kubectl get --show-kind --ignore-not-found -n NAMESPACE
How to delete all objects of a certain kind in a namespace?
$ kubectl get KIND -n NAMESPACE -o name | xargs -I{} kubectl delete {} -n NAMESPACE

# delete all resources of a certain KIND;
# -A for all namespaces
# --all for all objects
$ kubectl delete KIND -A --all
Check resource consumption
$ kubectl top node
$ kubectl top pod -A
Who Am I and What Can I Do?
Who Am I? Use whoami command to check username and groups:

$ kubectl auth whoami
ATTRIBUTE   VALUE
Username    kubernetes-admin
Groups      [system:masters system:authenticated]
This should match the cert:

$ cat /path/to/kubeconfig | yq '.users[0].user.client-certificate-data' | base64 -d | openssl x509 -text -noout | grep "Subject:"
Subject: O = system:masters, CN = kubernetes-admin
Check config

# Show current-context
$ kubectl config current-context

# Check details of the Config
$ kubectl config view

# use a different context
$ kubectl config use-context CONTEXT_NAME
What can i do?

# List all
$ kubectl auth can-i --list

# Check to see if I can do everything in my current namespace ("*" means all)
$ kubectl auth can-i '*' '*'

# Check to see if I can create pods in any namespace
$ kubectl auth can-i create pods --all-namespaces

# Check to see if I can list deployments in my current namespace
$ kubectl auth can-i list deployments.extensions
kubectl patch
3 types:

--type=strategy
--type=merge
--type=json
--type=strategy
The default. Not supported for Custom Resources.

$ kubectl patch serviceaccount NAME -n NAMESPACE -p '{"imagePullSecrets": [{"name": "IMAGE_PULL_SECRET_NAME"}]}'
From the go code:

exec.Command("kubectl", "patch", "serviceaccount",
    "NAME",
    "-n", "NAMESPACE",
    "-p", `'{"imagePullSecrets": [{"name": "IMAGE_PULL_SECRET_NAME"}]}'`).Run()
--type=json
$ kubectl patch KIND NAME -n NAMESPACE --type=json -p="[{'op': 'remove', 'path': '/metadata/finalizers'}]"
op can be: add, replace, remove.

Note that when setting an object to empty: replace with {} does not work ,use remove.

Read more: https://jsonpatch.com/

Search string in resources
# use grep, but hard to see which pod it is.
$ kubectl get pod -A -o yaml | grep "something"

# use jq, get pod name.
$ kubectl get pod -A -o json | jq -r '.items[] | select(tostring | contains("something")) | .metadata.name'
How to check Node Status
e.g. check ephemeral storage

$ kubectl get --raw "/api/v1/nodes/$NODE_NAME/proxy/stats/summary"

# equivalent to
$ curl http://$HOST:$PORT/api/v1/nodes/$NODE_NAME/proxy/stats/summary

# and
$ kubectl get --raw "/api/v1/nodes/$NODE_NAME/proxy/metrics/resource"
$ kubectl get --raw "/api/v1/nodes/$NODE_NAME/proxy/metrics/cadvisor"
Working with PV
Check capacities:

$ kubectl describe pv
$ kubectl describe pvc
The PV's Status should be "Bound" if it has been successfully allocated to the application.

Check remaining disk space:

$ kubectl -n NAMESPACE exec POD_NAME -- df -ah
More examples:

# How to get PVs of a namespace
$ kubectl get pv -o json | jq -r '.items[] | select(.spec.claimRef.namespace == "NAMESPACE") | .metadata.name'

# How to change the reclaim policies of the persistent volumes to Retain.
$ kubectl patch pv/${NAME} -p "{'spec':{'persistentVolumeReclaimPolicy':'Retain'}}"

# How to remove claimRef
$ kubectl patch pv/${NAME} --type json -p '[{"op":"remove","path":"/spec/claimRef"}]'
Working with Secret
# Get and decode secret
$ kubectl get secret SECRET_NAME -n NAMESPACE --template="{{index .data \"ca.crt\" | base64decode}}" > https.crt

# cert is stored in certificate-authority-data in kubeconfig
$ curl $(kubectl config view --minify --output 'jsonpath={..cluster.server}')
# curl: (60) SSL certificate problem: unable to get local issuer certificate

# get cert
$ kubectl config view --minify --raw --output 'jsonpath={..cluster.certificate-authority-data}' | base64 -d > /tmp/kubectl-cacert

$ curl --cacert /tmp/kubectl-cacert $(kubectl config view --minify --output 'jsonpath={..cluster.server}')
# should get 403
How to Get ClusterRoleBinding of a specific subject kind / name?
$ kubectl get clusterrolebindings -o json | jq -r '.items[] | select(.subjects[0].kind=="Group") | select(.subjects[0].name=="system:masters")'
How to Show init containers and normal containers.
$ kubectl get -A pod -o="custom-columns=NAME:.metadata.name,INIT-CONTAINERS:.spec.initContainers[*].name,CONTAINERS:.spec.containers[*].name"
How to apply a YAML?
Apply a file:

$ kubectl apply -f ./foo.yaml
Apply from commandline with raw text:

$ kubectl apply -f -  <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: example-namespace
EOF
How to force delete a CR (by deleting finalizers)?
Sometimes the CR deletion is blocked by finalizers, so the object will be stuck in Terminating state. To delete finalizers:

$ kubectl patch KIND NAME -n NAMESPACE --type=json -p="[{'op': 'remove', 'path': '/metadata/finalizers'}]"
How to check the x509 certificate?
# Check the cert in a Secret
$ kubectl get secret -n foo-system foo-serving-cert -o json | jq -r '.data."ca.crt"' | base64 -d | openssl x509 -text | less

# Check the cert in a CertificateRequest
$ kubectl get certificaterequest -n foo-system foo-serving-cert-p8795 -o json | jq -r '.status.ca' | base64 -d | openssl x509 -text | less
How to get more info about a field?
Use kubectl explain, e.g.

$ kubectl explain pod.spec.hostNetwork
How to get relevant events?
$ kubectl get event --namespace NAMESPACE --field-selector involvedObject.name=OBJECT_NAME
How to Renew a Certificate?
Certificates are stored by cert-manager inside a Secret, deleting this Secret triggers a certificate renewal.

Note: Delete the Secret holding the certificate, not the Certificate itself.

# Get the name of the Secret:
SECRET_NAME=$(kubectl -n foo-system get Certificate foo-serving-cert -o jsonpath='{.spec.secretName}')

# Delete the Secret to trigger certificate renewal.
$ kubectl --kubeconfig ${KUBECONFIG:?} -n gpc-system delete Secret ${SECRET_NAME}
How to deal with kinds with the same name?
If you have multiple types named Cluster, you can specify the one with KIND.VERSION.GROUP.

For example, to delete the Cluster in v1 of foo.example.com group:

$ kubectl delete clusters.v1.foo.example.com NAME -n NAMESPACE
How to add/modify and remove annotation?
# add or modify an annotation
$ kubectl annotate KIND NAME -n NAMESPACE foo.example.com/paused=true

# remove an annotation, add `-` at the end
$ kubectl annotate KIND NAME -n NAMESPACE foo.example.com/paused-
How to test certificate from commandline?
$ kubectl get secret SECRET_NAME -n cert-manager -ojsonpath='{.data.ca\.crt}' |  base64 --decode > trust.crt

$ openssl s_client -connect some.domain.example.com:443  -CAfile trust.crt
How to save full logs?
Sometimes the logs may be rotated out. To save the full log for debugging, dump the logs:

while true ; do kubectl logs -l name=label-name -n foo-system --tail -1 > $(date +"%Y-%m-%d-%H-%M-%S")-log; sleep 30 ; done
How to remove unnecessary fields when dumping the manifest?
$ kubectl get KIND NAME -n NAMESPACE -o json | \
    jq "del(.status, .metadata.annotations, .metadata.creationTimestamp,
            .metadata.finalizers, .metadata.generation,
            .metadata.resourceVersion, .metadata.uid)" > md.json
How to find all possible clusters in a kubeconfig?
Your KUBECONFIG may have multiple contexts:

$ kubectl config view -o jsonpath='{"Cluster name\tServer\n"}{range .clusters[*]}{.name}{"\t"}{.cluster.server}{"\n"}{end}'
How to update ConfigMaps?
# see what changes would be made, returns nonzero returncode if different
$ kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
$ kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
How to update status?
The normal kubectl patch cannot change status. Add --subresource=status:

$ kubectl patch KIND NAME -n NAMESPACE --subresource=status --type=json -p="[{'op': 'replace', 'path': '/status/myConditions/0/status', 'value': 'True'}]"
Note that if /status/myConditions is a list, you can select the first one by /status/myConditions/0/status.

Or use --type=merge:

$ kubectl patch KIND NAME -n NAMESPACE --type=merge --subresource=status -p '{
   "status": {
      "conditions": [{
         "type": "...",
         "status": "True",
         "reason": "...",
         "message": "...",
         "lastTransitionTime": "1900-10-10T00:00:00Z"
      }]
   }
}'
How to get raw info?
# Check API priority and fairness
$ kubectl get --raw /debug/api_priority_and_fairness/dump_priority_levels
$ kubectl get --raw /debug/api_priority_and_fairness/dump_queues
$ kubectl get --raw /debug/api_priority_and_fairness/dump_requests

# Check status
$ kubectl get --raw='/readyz?verbose'
How to debug?
Use kubectl debug command to attach the container directly to the problematic pod for debugging.

How to expose a NodePort?
$ kubectl expose deployment nginx --port 80 --type NodePort

$ NODE_PORT=$(kubectl get svc nginx \
  --output=jsonpath='{range .spec.ports[0]}{.nodePort}')

$ curl -I http://localhost:${NODE_PORT}
Plugins
Add the tree plugin to visualize

$ kubectl krew install tree
Full list of plugins: https://github.com/kubernetes-sigs/krew-index/tree/master/plugins

Well-known ports
6443: API Server (or haproxy)
2379/2380: etcd
10250: kubelet
10256: kube-proxy
10257: kube-controller-manager
10259: kube-scheduler
30000-32767: NodePort Services
Troubleshooting
Unable to use a TTY - input is not a terminal or the right kind of file
If you see this error when running kubectl exec -it, try to remove -t.

Deprecation
kubectl kustomize subcommand, --kustomize flag are being deprecated. kustomize will be added in krew index. https://github.com/kubernetes/enhancements/blob/master/keps/sig-cli/4706-deprecate-and-remove-kustomize/README.md