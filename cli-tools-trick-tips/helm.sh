Helm
Talking to an OCI registry
Starting from Helm v3.8.0, OCI support is enabled by default.

Image name in the registry: <domain>/<project>/<repository>:<tag>.

# login
$ helm registry login -u admin xx.xx.xx.xx
Password:
Login Succeeded

# push
$ helm push mychart-0.1.0.tgz oci://localhost:5000/helm-charts

# pull from an OCI registry
$ helm pull oci://10.200.0.1/foo/bar --version 1.2.3
Note for Harbor users: there's no /v2 in the uri.

Talking to a K8s Cluster
Use --kubeconfig=KUBECONFIG when your kubeconfig is not at the default location.

Lifecycle: Install / Uninstall / Upgrade / Rollback
# Install bar/baz from the repo and name it foo
$ helm install foo bar/baz

# Generate a name
$ helm install bar/baz --generate-name

# Install from an unpacked chart dir
$ helm install foo /path/to/baz

# Install from a full url
$ helm install foo https://example.com/charts/foo-1.2.3.tgz

# Install a local chart archive
$ helm install foo foo-0.1.1.tgz

# Uninstall
$ helm uninstall foo
$ helm uninstall foo --keep-history

# Upgrade
$ helm upgrade foo [RELEASE] [CHART] [flags]

# If something goes wrong, rollback manually
$ helm rollback $CHART -n $NAMESPACE --kubeconfig /path/to/kubeconfig
Inspect
# List all deployed releases
$ helm list

# Include uninstalled releases
$ helm list --all

# List releases in all name spaces
$ helm list --all-namespaces

# If you have multiple clusters/kubeconfigs
$ helm list --kubeconfig=KUBECONFIG

# Check status
$ helm status $RELEASE

# Print out metadata and all yamls of the chart
$ helm get all $RELEASE -n $NAMESPACE --kubeconfig /path/to/kubeconfig

# Or just print part of the info
$ helm get hooks $RELEASE      # download all hooks for a named release
$ helm get manifest $RELEASE   # download the manifest for a named release
$ helm get notes $RELEASE      # download the notes for a named release
$ helm get values $RELEASE     # download the values file for a named release

# Check history of a chart
$ helm history $RELEASE -n $NAMESPACE --kubeconfig /path/to/kubeconfig

# Check helm envs
$ helm env
Charts
# Create a folder with common files.
$ helm create $CHART

# Validate and format.
$ helm lint $CHART

# Package the chart up for distribution.
# This creates a .tgz that is ready for `helm install`.
$ helm package $CHART

# List dependencies of a chart.
$ helm dependency list $CHART

# Inspect the content of a chart
$ helm show all $CHART
List all resources managed by the helm
Use label selector with label app.kubernetes.io/managed-by=Helm:

$ kubectl get all --all-namespaces -l='app.kubernetes.io/managed-by=Helm'
Chart File Structure
my-chart/
  charts/       # dependent charts
  crds/         # Custom Resource Definitions
  templates/    # templates
  Chart.yaml    # info about the chart
  values.yaml   # default values
Template + values = a valid k8s manifest.

FAQ
What happens in helm install
helm install:

install CRDs in crds/ folder.
renders the templates.
pre-install hook.
creates/updates k8s resources.
post-install hook.
How to Create a hook
add the annotation to the yaml (e.g. a Job)
metadata.annotations."helm.sh/hook": pust-install
Where is the release info stored?
When we run helm list --kubeconfig KUBECONFIG, it pulls release info from that cluster. Where is that release info stored?

Helm 3 default: Secrets
Helm 2 default: ConfigMap
configurable by HELM_DRIVER env variable: [configmap, secret, sql]
Why Secret? The release information includes the contents of charts and values files, and therefore might contain sensitive data like passwords, private keys, and other credentials.

Why sql? Secret and ConfigMap are stored in etcd, 1mb limit

To use sql:

export HELM_DRIVER=sql
export HELM_DRIVER_SQL_CONNECTION_STRING=postgresql://helm-postgres:5432/helm?user=helm&password=changeme
What's the difference among CHART, RELEASE and REVISION?
CHART: a package of manifests (i.e. YAMLs) for deploying an app to k8s. A chart can be stored in a registry, the manifests inside the chart may have references to the images in the registry, but the chart itself does not include the images (and the size limit of a chart is usually 1 MB).
RELEASE: a running instance of a chart in a K8s cluster; One chart can often be installed many times into the same cluster; e.g. one MySQL chart but many databases instances running in the cluster, each is a "release".
REVISION: tracks the number of changes on a RELEASE.
Why "helm list" shows nothing?
Check the flags you are using:

specify namespace by -n or use --all-namespaces.
use --all to show all.
use --kubeconfig to specify the correct kubeconfig file.
$ helm ls --all-namespaces --all --kubeconfig KUBECONFIG
Troubleshooting
Use --debug
If you see any error in your helm command, add --debug to get more info.

Error: Too long: must have at most 1048576 bytes
Helm v3 stores chart state in a Kubernetes secret by default. Kubernetes secrets are limited to a max size based on etcd's configuration. The default etcd configuration limits secrets to a maximum size of 1MB. If you see this error, you need to reduce the size of your chart:

Error: create: failed to create: Secret “sh.helm.release.v1.MY_CHART_NAME.v1” is invalid: data: Too long: must have at most 1048576 bytes
Error: manifest does not contain minimum number of descriptors (2), descriptors found: 1
Maybe you are not pulling a "chart", not everything in the registry is a "chart"; "chart" and non-chart have different minimum number of descriptors.

"Could not locate a version matching provided version string"
Version should be specified by --version instead of as a suffix (chart:version).

$ helm pull oci://10.200.0.1/foo/bar --version 1.2.3
Helm Hook
"Hook" is just an annotation in the metadata of the yaml:

helm.sh/hook: the yaml will be in effect in the specified stage.
helm.sh/hook-weight: hooks will run in the ascending order of the weights.
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: foo-deployhook-clusterrole
  annotations:
    'helm.sh/hook': post-install,post-upgrade
    'helm.sh/hook-weight': '-1'
    'helm.sh/hook-delete-policy': before-hook-creation,hook-succeeded
helm.sh/hook values: pre-install, post-install, pre-delete, post-delete, pre-upgrade, post-upgrade, pre-rollback, post-rollback.

helm.sh/hook-delete-policy values:

before-hook-creation: Delete the previous resource before a new hook is launched (default)
hook-succeeded: Delete the resource after the hook is successfully executed
hook-failed: Delete the resource if the hook failed during execution
Ownership
Helm internally uses labels and annotations to track the ownership of the managed resources to prevent multiple charts owning the same resources and causing glitches during upgrade/deletion. You can implicitly change resource ownership in a lot of ways. For example, renaming helm charts, merging helm charts, splitting helm charts, adding a new chart with existing resources in previous installation, these operations all cause change of ownership.

Helm SDK
Client works with OCI-compliant registries; Harbor is one of them. From go code:

import (
  // ...
  "helm.sh/helm/v3/pkg/registry"
)

// Create a new client
client, err := registry.NewClient()

// Push to the registry
info, err := client.Push(b, "localhost:5000/mycharts/foo:0.1.0")
Deprecated
Helm ChartMuseum is deprecated; newer versions of helm can fetch and upload charts in any OCI compliant registry.
Harbor and Helm
Circular dependencies:

Helm charts can live in Harbor.
Harbor can be installed to k8s by Helm.
The chart to install Harbor is stored in https://helm.goharbor.io.

$ helm repo add harbor https://helm.goharbor.io
$ helm repo list # find harbor in the list
$ helm fetch harbor/harbor --untar # this downloads the chart to a local `harbor` folder

# modify harbor/values.yaml

# install the chart in `harbor` as `my-release`
$ helm install my-release harbor
Dependencies
ORAS
ORAS is used by Helm as the underlying library for working with registries.

cli-runtime
k8s.io/cli-runtime/pkg/genericclioptions/config_flags.go

Helm init takes a genericclioptions.RESTClientGetter

vendor/helm.sh/helm/v3/pkg/action/action.go

vendor/helm.sh/helm/v3/pkg/kube/client.go
kube.New(getter) takes a RESTClientGetter to create a Client

chart.Apply(restClientGetter, installOptions) to install charts