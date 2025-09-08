Ceph
CLI
# Check status
ceph -s
ceph status

# Help
ceph -h
If Ceph is not deployed in cluster:

# Check status
$ systemctl status ceph

# Restart Ceph
$ systemctl restart ceph

# Check logs
$ journalctl -u ceph
Related Objects:

apiVersion: storage.k8s.io/v1
kind: CSIDriver

apiVersion: ceph.rook.io/v1
kind: CephCluster
CephCluster is showing the same info as in ceph -s.

Ceph vs Rook
Ceph is the Storage.
Rook is the Storage Operator: It automates the tasks of a storage administrator: deployment, bootstrapping, configuration, provisioning, scaling, upgrading, migration, disaster recovery, monitoring, and resource management.
Block, FS, Object
RADOS: Reliable Autonomous Distributed Object Store. A low-level data store that provides a common backend for multiple user-consumable services. Ceph's foundation.

RBD: RADOS Block Device. The block storage which can be assigned to pods. Usually RWO.
OSD: Object Storage Device: Ceph OSD daemons to provide RADOS storage.
CephFS: shared filesystem volumes, usually RWX.
Components
Object Storage Devices (OSDs). An OSD in RADOS is always a folder within an existing filesystem. All OSDs together form the object store proper, and the binary objects that RADOS generates from the files to be stored reside in the store. The hierarchy within the OSDs is flat: files with UUID-style names but no subfolders. ceph-osd is the object storage daemon.
Ceph Monitor (MON): MONs form the interface to the RADOS store and support access to the objects within the store. They handle communication with all external applications and work in a decentralized way.
Ceph Manager (MGR)
Ceph Metadata Server (MDS)
Ceph Object Gateway (RGW)
Deployment in Kubernetes
2 ways to use Ceph

(in cluster) as containerized workload: replication x3, ha,
(external) as non-containerized: directly run on the machine, deployed as part of systemd.
Either way

rook-ceph-operator will manage damonsets like csi-rbdplugin.
default namespace: rook-ceph.
In cluster
(Ceph requires 3 nodes to run in containerized mode.)

rook-ceph-operator
rook-ceph-mgr
rook-ceph-mon
rook-ceph-osd
External
An external cluster is a Ceph configuration that is managed outside of the local K8s cluster. The external cluster could be managed by cephadm.

How to check if Ceph is external? Check if CephCluster has .spec.external.enable: true.

If external, you will only find this in the cluster:

rook-ceph-operator
Troubleshooting
If you are seeing issues provisioning the PVC then you need to check the network connectivity from the provisioner pods.

For CephFS PVCs, check network connectivity from the csi-cephfsplugin container of the csi-cephfsplugin-provisioner pods
For Block PVCs, check network connectivity from the csi-rbdplugin container of the csi-rbdplugin-provisioner pods
Placement Group
PG = “placement group”. When placing data in the cluster, objects are mapped into PGs, and those PGs are mapped onto OSDs.

Why the indirection? "so that we can group objects, which reduces the amount of per-object metadata we need to keep track of and processes we need to run".

Ceph Under the hood
Block storage

App creates a PVC to request storage
The PVC specifies the Ceph RBD StorageClass
K8s calls the Ceph-CSI RBD provisioner to create the Ceph RBD image.
The kubelet calls the CSI RBD volume plugin to mount the volume in the app
The volume is now available for reads and writes.
File storage

The PVC specifies the CephFS StorageClass for provisioning the storage
The kubelet calls the CSI CephFS volume plugin to mount the volume in the app
Object storage

The app creates an ObjectBucketClaim (OBC) to request a bucket
The Rook operator creates a Ceph RGW bucket (via the lib-bucket-provisioner)
The Rook operator creates a secret with the credentials for accessing the bucket and a configmap with bucket information
The app retrieves the credentials from the secret
The app can now read and write to the bucket with an S3 client
https://rook.io/docs/rook/latest-release/Getting-Started/storage-architecture/

Source Code
Ceph: https://github.com/ceph/ceph (C++)
Ceph CSI: CSI driver for Ceph https://github.com/ceph/ceph-csi/ (Go)
Rook: https://github.com/rook/rook (Go)