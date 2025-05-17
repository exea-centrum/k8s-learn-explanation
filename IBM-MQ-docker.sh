david@lmde:/tmp/refarch-integration-inventory-dal$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
docker pull icr.io/ibm-messaging/mq:latest

docker images
docker volume create qm1data



david@lmde:/tmp/refarch-integration-inventory-dal$ docker run --env LICENSE=accept --env MQ_QMGR_NAME=QM1 --volume qm1data:/mnt/mqm --publish 1414:1414 --publish 9443:9443 --detach --env MQ_APP_USER=app --env MQ_APP_PASSWORD=passw0rd --env MQ_ADMIN_USER=admin --env MQ_ADMIN_PASSWORD=passw0rd --name QM1 icr.io/ibm-messaging/mq:latest
Unable to find image 'icr.io/ibm-messaging/mq:latest' locally
latest: Pulling from ibm-messaging/mq
9d561c17444a: Pull complete 
adc97f92dbce: Pull complete 
850686cdbc56: Pull complete 
1d217d6c6ddd: Pull complete 
b530ce9cc9e0: Pull complete 
f1edf2ea75ee: Pull complete 
d303376a4617: Pull complete 
d88256bb4f8e: Pull complete 
5b034e3dada3: Pull complete 
eb0bd5cd599c: Pull complete 
3323cb5ac3f9: Pull complete 
57716f8a7c8a: Pull complete 
5c73fc8f4bad: Pull complete 
8b340dd0460e: Pull complete 
42b50dbea8a9: Pull complete 
683cae9691dc: Pull complete 
83a297ff14e5: Pull complete 
dc57d1cb0594: Pull complete 
327f686593d7: Pull complete 
b1db826d57a2: Pull complete 
Digest: sha256:4a0f207897b650841a566b6acd7e5701dc8a0e11e617be1963dcc33619d2442c
Status: Downloaded newer image for icr.io/ibm-messaging/mq:latest
e4b57e2369085db6491c7620ac0c4194727e2e0e82a515df78b83a003d58081b

david@lmde:/tmp/refarch-integration-inventory-dal$ docker exec -ti QM1 bash
bash-5.1$ dspmqver
Name:        IBM MQ
Version:     9.4.2.1
Level:       p942-001-250407
BuildType:   IKAP - (Production)
Platform:    IBM MQ for Linux (x86-64 platform)
Mode:        64-bit
O/S:         Linux 6.1.0-34-amd64
O/S Details: Red Hat Enterprise Linux 9.5 (Plow)
InstName:    Installation1
InstDesc:    IBM MQ V9.4.2.1 (Unzipped)
Primary:     N/A
InstPath:    /opt/mqm
DataPath:    /mnt/mqm/data
MaxCmdLevel: 942
LicenseType: Developer
ReleaseType: Continuous Delivery (CD)
bash-5.1$ Queue manager QM1
bash: Queue: command not found
david@lmde:/tmp$ microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
error: error upgrading connection: error dialing backend: dial tcp 192.168.1.24:10250: connect: connection refused
david@lmde:/tmp$ microk8s status
microk8s is running
high-availability: no
  datastore master nodes: 127.0.0.1:19001
  datastore standby nodes: none
addons:
  enabled:
    argocd               # (community) Argo CD is a declarative continuous deployment for Kubernetes.
    dashboard-ingress    # (community) Ingress definition for Kubernetes dashboard
    fluentd              # (community) Elasticsearch-Fluentd-Kibana logging and monitoring
    gopaddle             # (community) DevSecOps and Multi-Cloud Kubernetes Platform
    istio                # (community) Core Istio service mesh services
    openfaas             # (community) OpenFaaS serverless framework
    cert-manager         # (core) Cloud native certificate management
    community            # (core) The community addons repository
    dashboard            # (core) The Kubernetes dashboard
    dns                  # (core) CoreDNS
    ha-cluster           # (core) Configure high availability on the current node
    helm                 # (core) Helm - the package manager for Kubernetes
    helm3                # (core) Helm 3 - the package manager for Kubernetes
    hostpath-storage     # (core) Storage class; allocates storage from host directory
    ingress              # (core) Ingress controller for external access
    metrics-server       # (core) K8s Metrics Server for API access to service metrics
    registry             # (core) Private image registry exposed on localhost:32000
    storage              # (core) Alias to hostpath-storage add-on, deprecated
  disabled:
    cilium               # (community) SDN, fast with full network policy
    easyhaproxy          # (community) EasyHAProxy can configure HAProxy automatically based on ingress labels
    inaccel              # (community) Simplifying FPGA management in Kubernetes
    jaeger               # (community) Kubernetes Jaeger operator with its simple config
    kata                 # (community) Kata Containers is a secure runtime with lightweight VMS
    keda                 # (community) Kubernetes-based Event Driven Autoscaling
    knative              # (community) Knative Serverless and Event Driven Applications
    kubearmor            # (community) Cloud-native runtime security enforcement system for k8s
    kwasm                # (community) WebAssembly support for WasmEdge (Docker Wasm) and Spin (Azure AKS WASI)
    linkerd              # (community) Linkerd is a service mesh for Kubernetes and other frameworks
    microcks             # (community) Open source Kubernetes Native tool for API Mocking and Testing
    multus               # (community) Multus CNI enables attaching multiple network interfaces to pods
    nfs                  # (community) NFS Server Provisioner
    ondat                # (community) Ondat is a software-defined, cloud native storage platform for Kubernetes.
    openebs              # (community) OpenEBS is the open-source storage solution for Kubernetes
    osm-edge             # (community) osm-edge is a lightweight SMI compatible service mesh for the edge-computing.
    parking              # (community) Static webserver to park a domain. Works with EasyHAProxy.
    portainer            # (community) Portainer UI for your Kubernetes cluster
    shifu                # (community) Kubernetes native IoT software development framework.
    sosivio              # (community) Kubernetes Predictive Troubleshooting, Observability, and Resource Optimization
    traefik              # (community) traefik Ingress controller
    trivy                # (community) Kubernetes-native security scanner
    cis-hardening        # (core) Apply CIS K8s hardening
    gpu                  # (core) Automatic enablement of Nvidia CUDA
    host-access          # (core) Allow Pods connecting to Host services smoothly
    kube-ovn             # (core) An advanced network fabric for Kubernetes
    mayastor             # (core) OpenEBS MayaStor
    metallb              # (core) Loadbalancer for your Kubernetes cluster
    minio                # (core) MinIO object storage
    observability        # (core) A lightweight observability stack for logs, traces and metrics
    prometheus           # (core) Prometheus operator for monitoring and logging
    rbac                 # (core) Role-Based Access Control for authorisation
    rook-ceph            # (core) Distributed Ceph storage using Rook
david@lmde:/tmp$ microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
Forwarding from 127.0.0.1:10443 -> 8443
Forwarding from [::1]:10443 -> 8443
Handling connection for 10443
Handling connection for 10443
Handling connection for 10443
Handling connection for 10443
Handling connection for 10443
Handling connection for 10443
Handling connection for 10443




Running with the default configuration
You can run a queue manager with the default configuration and a listener on port 1414 using the following command. For example, the following command creates and starts a queue manager called QM1, and maps port 1414 on the host to the MQ listener on port 1414 inside the container, as well as port 9443 on the host to the web console on port 9443 inside the container:

docker run \
  --env LICENSE=accept \
  --env MQ_QMGR_NAME=QM1 \
  --publish 1414:1414 \
  --publish 9443:9443 \
  --detach \
  icr.io/ibm-messaging/mq
Running with the default configuration and a volume
The above example will not persist any configuration data or messages across container runs. In order to do this, you need to use a volume. For example, you can create a volume with the following command:

docker volume create qm1data
You can then run a queue manager using this volume as follows:

docker run \
  --env LICENSE=accept \
  --env MQ_QMGR_NAME=QM1 \
  --publish 1414:1414 \
  --publish 9443:9443 \
  --detach \
  --volume qm1data:/mnt/mqm \
  icr.io/ibm-messaging/mq
The Docker image always uses /mnt/mqm for MQ data, which is correctly linked for you under /var/mqm at runtime. This is to handle problems with file permissions on some platforms.

Running with the default configuration and Prometheus metrics enabled
You can run a queue manager with Prometheus metrics enabled. The following command will generate Prometheus metrics for your queue manager on /metrics port 9157 via HTTP:

docker run \
  --env LICENSE=accept \
  --env MQ_QMGR_NAME=QM1 \
  --env MQ_ENABLE_METRICS=true \
  --publish 1414:1414 \
  --publish 9443:9443 \
  --publish 9157:9157 \
  --detach \
  icr.io/ibm-messaging/mq
To configure a queue manager to serve metrics via HTTPS, TLS keys must be provided in /etc/mqm/metrics/pki/keys. These files must be PEM encoded certificates named tls.key (server public certificate) and tls.crt (server private key), you may optionally provide a ca.crt file (CA public certificate). If no TLS keys are provided, an HTTP server will be used. The following command will generate Prometheus metrics for your queue manager on /metrics port 9157 via HTTPS:

docker run \
  --env LICENSE=accept \
  --env MQ_QMGR_NAME=QM1 \
  --env MQ_ENABLE_METRICS=true \
  -v "<TLS_DIR>:/etc/mqm/metrics/pki/keys" \
  --publish 1414:1414 \
  --publish 9443:9443 \
  --publish 9157:9157 \
  --detach \
  icr.io/ibm-messaging/mq
Note: <TLS_DIR> should be replaced with a directory in which you have the required TLS files.

Customizing the queue manager configuration
You can customize the configuration in several ways:

For getting started, you can use the default developer configuration, which is available out-of-the-box for the MQ Advanced for Developers image
By creating your own image and adding your own MQSC file into the /etc/mqm directory on the image. This file will be run when your queue manager is created.
By using remote MQ administration, via an MQ command server, the MQ HTTP APIs, or using a tool such as the MQ web console or MQ Explorer.
Note that a listener is always created on port 1414 inside the container. This port can be mapped to any port on the Docker host.

The following is an example Dockerfile for creating your own pre-configured image, which adds a custom MQ configuration file:

FROM icr.io/ibm-messaging/mq
USER 1001
COPY 20-config.mqsc /etc/mqm/
Here is an example corresponding 20-config.mqsc script, which creates two local queues:

DEFINE QLOCAL(MY.QUEUE.1) REPLACE
DEFINE QLOCAL(MY.QUEUE.2) REPLACE
The file 20-config.mqsc should be saved into the same directory as the Dockerfile.

Running MQ commands
It is recommended that you configure MQ in your own custom image. However, you may need to run MQ commands directly inside the process space of the container. To run a command against a running queue manager, you can use docker exec, for example:

docker exec \
  --tty \
  --interactive \
  ${CONTAINER_ID} \
  dspmq
Using this technique, you can have full control over all aspects of the MQ installation. Note that if you use this technique to make changes to the filesystem, then those changes would be lost if you re-created your container unless you make those changes in volumes.

Supplying TLS certificates
If you wish to supply TLS Certificates that the queue manager and MQ Console should use for TLS operations then you must supply a PKCS#1 or unencrypted PKCS#8 PEM files for both the certificates and private keys in the following directories:

/etc/mqm/pki/keys/<Label> - for certificates with public and private keys
/etc/mqm/pki/trust/<index> - for certificates with only the public key
For example, if you have an identity certificate you wish to add with the label mykey and 2 certificates you wish to add as trusted then you would need to add the files into the following locations where files ending in .key contain private keys and .crt contain certificates:

/etc/mqm/pki/keys/mykey/tls.key
/etc/mqm/pki/keys/mykey/tls.crt
/etc/mqm/pki/keys/mykey/ca.crt
/etc/mqm/pki/trust/0/tls.crt
/etc/mqm/pki/trust/1/tls.crt
This can be achieved by either mounting the directories or files into the container when you run it or by baking the files into the correct location in the image.

If you supply multiple identity certificates then the first label alphabetically will be chosen as the certificate to be used by the MQ Console and the default certificate for the queue manager. If you wish to use a different certificate on the queue manager then you can change the certificate to use at runtime by executing the MQSC command ALTER QMGR CERTLABL('<newlabel>')

It must be noted that queue manager certificate with a Subject Distinguished Name (DN) same as it's Issuer certificate (CA) is not supported. Certificates must have a unique Subject Distinguished Name.

Running with a read-only root filesystem
Starting with version 9.3.4.0, you can run MQ container with a read-only root filesystem. In order to do this, you need to mount three volumes into the MQ container, one for queue manager data, one for run directory that will contain files used for queue manager configuration and one for tmp directory that will be used for collecting diagnostic data. You also need specify --read-only parameter while starting the container. Following describes the steps to run MQ container with a read-only root filesystem.

docker volume create qm1data
docker volume create run
docker volume create tmp
You can then run a queue manager with a read-only root filesystem as follows:

docker run \
  --env LICENSE=accept \
  --env MQ\_QMGR\_NAME=QM1 \
  --mount type=volume,source=run,destination=/run \
  --mount type=volume,source=tmp,destination=/tmp \
  --mount type=volume,source=qm1data,destination=/mnt/mqm \
  --read-only \
  --publish 1414:1414 \
  --detach \
  icr.io/ibm-messaging/mq
