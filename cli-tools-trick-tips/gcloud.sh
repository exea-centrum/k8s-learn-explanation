gcloud CLI
The gcloud command-line interface is the primary CLI tool to create and manage Google Cloud resources.

Authentication & Authorization
# Login with User Account: Opens a browser window for authentication.
gcloud auth login

# Login with Service Account: Use a key file.
gcloud auth activate-service-account --key-file=/path/to/key.json

# List Authenticated Accounts:
gcloud auth list

# Set Active Account:
gcloud config set account ACCOUNT_EMAIL

# Revoke Credentials:
gcloud auth revoke ACCOUNT_EMAIL

# Print Access Token:
gcloud auth print-access-token

# Print Identity Token:
gcloud auth print-identity-token
gcloud auth login (no --update-adc) would populate your user credentials into a sqlitedb under .config/gcloud/

If you use gcloud cli, by default it'll use those creds it finds there.

Configuration Management
# List Configurations:
gcloud config configurations list

# Create a New Configuration:
gcloud config configurations create my-config-name

# Activate a Configuration:
gcloud config configurations activate my-config-name

# Describe a Configuration:
gcloud config configurations describe my-config-name

# List Current Configuration Settings:
gcloud config list

# Set a Property (Project, Region, Zone):
gcloud config set project ${PROJECT_ID}
gcloud config set compute/region ${REGION} # e.g., us-central1
gcloud config set compute/zone ${ZONE}     # e.g., us-central1-a

# Unset a Property:
gcloud config unset compute/zone

# Get a Specific Property Value:
gcloud config get-value project
What's my current Project?
To check the current project:

gcloud config get-value project

# or find the project in the full config
gcloud config list
To set project:

gcloud config set project
To list the projects you have access to:

gcloud projects list
What's my current Organization?
gcloud doesn't have a direct configuration setting for a "current organization" in the same way it has for a "current project".

To get the associated org of the current project:

gcloud projects get-ancestors $(gcloud config get-value project)
To list the organizations you have access to:

gcloud organizations list
Common Service Commands
Replace [PLACEHOLDERS] with your values.

Compute Engine (GCE)
# List instances:
gcloud compute instances list
gcloud compute instances list --project=${PROJECT_ID} --zones=${ZONE}
gcloud compute instances list --project=${PROJECT_ID} --zones=us-central1-a --format="value(name)"

# Describe instance:
gcloud compute instances describe ${INSTANCE_NAME} --zone=${ZONE}

# Create instance:
gcloud compute instances create ${INSTANCE_NAME} --zone=${ZONE} --machine-type=e2-medium --image-project=debian-cloud --image-family=debian-11

# Stop instance:
gcloud compute instances stop ${INSTANCE_NAME} --zone=${ZONE}

# Start instance:
gcloud compute instances start ${INSTANCE_NAME} --zone=${ZONE}

# Delete instance:
gcloud compute instances delete ${INSTANCE_NAME} --zone=${ZONE}

# SSH into instance:
gcloud compute ssh ${INSTANCE_NAME} --zone=${ZONE}

# SSH and run a command: e.g. install a .deb package
gcloud compute ssh ${INSTANCE_NAME} \
  --project=${PROJECT_ID} \
  --zone=us-west1-a \
  --command='dpkg -i /path/to/my.deb'

# Copy from Local to Remote::
gcloud compute scp /local/path ${INSTANCE_NAME}:/remote/path --zone=${ZONE} --project ${PROJECT_ID}

# Copy from Remote to Local:
gcloud compute scp ${INSTANCE_NAME}:/remote/path /local/path --zone=${ZONE} --project ${PROJECT_ID}

# List disks of a project:
gcloud compute disks list --project=${PROJECT_ID} --zones=${ZONE}

# Delete disks with time filter and name filter:
gcloud compute disks delete $(gcloud compute disks list --project=${PROJECT_ID} --zones=${ZONE} --filter="creationTimestamp<'2025-05-18'" --format='value(name)' | grep NAME_PATTERN) --project=${PROJECT_ID} --zone=${ZONE}

# Create a firewall rule to allow RDP (Remote Desktop Protocol) ingress
gcloud compute firewall-rules create allow-rdp-ingress-from-iap \
  --direction=INGRESS \
  --action=allow \
  --rules=tcp:3389 \
  --project=${PROJECT_ID} \
  --source-ranges=35.235.240.0/20

# Create a firewall rule to allow SSH ingress
gcloud compute firewall-rules create allow-ssh-ingress-from-iap \
  --direction=INGRESS \
  --action=allow \
  --rules=tcp:22 \
  --project=${PROJECT_ID} \
  --source-ranges=35.235.240.0/20
Kubernetes Engine (GKE)
# List clusters:
gcloud container clusters list

# Describe cluster: (or `--zone`)
gcloud container clusters describe CLUSTER_NAME --region=${REGION}

# Create cluster:
gcloud container clusters create CLUSTER_NAME --region=${REGION} --num-nodes=1

# Get credentials (configures `kubectl`):
gcloud container clusters get-credentials CLUSTER_NAME --region=${REGION}

# Delete cluster:
gcloud container clusters delete CLUSTER_NAME --region=${REGION}
Artifacts Registry
# Create a repository
# FORMAT can be `docker`, `maven`, `npm`, `python`, etc.
# LOCATION is like `us-central1` or `us`
gcloud artifacts repositories create REPOSITORY_NAME \
    --repository-format=${FORMAT} \
    --location=${LOCATION}

# List repositories
gcloud artifacts repositories list --project=${PROJECT_ID}

# List docker images
gcloud artifacts docker images list ${LOCATION}-docker.pkg.dev/${PROJECT_ID}/REPOSITORY_NAME
Cloud Build
gcloud builds submit --tag ${LOCATION}.pkg.dev/${PROJECT_ID}/container-images/${IMAGE_NAME} ./local/folder
Cloud Storage (GCS)
gcloud storage is preferred over legacy gsutil.

Buket name: Prefer - over _. For DNS compliance and future compatibility, you should not use underscores in bucket names. Hyphens are considered standard DNS characters.

# List buckets:
gcloud storage buckets list

# List objects in bucket:
gcloud storage ls gs://${BUCKET_NAME}

# Create bucket
# `--location=us-central1` for a single region
# `--location=US` for multiregion
gcloud storage buckets create gs://${BUCKET_NAME} --location=${LOCATION}

# Update lifecycle configs, e.g. auto delete after 2 days:
# Create a gcs_lifecycle_management.json with:
# {
#   "rule": [
#     {
#       "action": {"type": "Delete"},
#       "condition": {"age": 2}
#     }
#   ]
# }
gcloud storage buckets update "gs://${BUCKET_NAME}" --lifecycle-file=path/to/gcs_lifecycle_management.json

# Check bucket configs (including lifecycle configs):
gcloud storage buckets describe gs://${BUCKET_NAME}

# Copy from Local to Bucket:
gcloud storage cp /local/file gs://${BUCKET_NAME}/

# Copy from Bucket to Local:
gcloud storage cp gs://${BUCKET_NAME}/object /local/dir/

# Copy from Bucket to Bucket:
gcloud storage cp gs://[BUCKET1]/obj1 gs://[BUCKET2]/obj2

# Move/Rename object:
gcloud storage mv gs://[BUCKET]/old_name gs://[BUCKET]/new_name

# Remove object:
gcloud storage rm gs://${BUCKET_NAME}/object_name

# Remove bucket (must be empty):
gcloud storage rm --recursive gs://${BUCKET_NAME}

# Delete bucket (Use `buckets delete` for non-empty):
gcloud storage buckets delete gs://${BUCKET_NAME}

# Count files in a GCS bucket
gcloud storage du gs://${BUCKET_NAME}  | wc -l
# This may take a long time; if you have access to Cloud Console:
# Monitoring => Metrics explorer => add metric "GCS Bucket - Object count" => set filters like bucket_name

# Get the total size of a GCS bucket
gcloud storage du gs://${BUCKET_NAME} --summarize
# This may take a long time; if you have access to Cloud Console:
# Monitoring => Metrics explorer => add metric "GCS Bucket - Total bytes" => set filters like bucket_name

# Make the bucket publicly viewable
gcloud storage buckets add-iam-policy-binding gs://${BUCKET_NAME} \
  --member=allUsers --role=roles/storage.objectViewer

# Add CORS policy
# Create a JSON file (e.g. cors.json)
# [
#   {
#     "origin": ["*"],
#     "method": ["GET"],
#     "maxAgeSeconds": 3600
#   }
# ]
gcloud storage buckets update gs://${BUCKET_NAME} --cors-file=cors.json

# Check cors setting, look for cors in
gcloud storage bucket describe gs://${BUCKET_NAME}
Secret Manager
# Enable Secret Manager
gcloud services enable secretmanager.googleapis.com

# Verify Secret Manager service status
gcloud services list --filter="secretmanager"

# Create a new secret
# For simple secret like API KEY
echo "YOUR_SECRET_VALUE" | gcloud secrets create ${SECRET_NAME} --data-file=-
# For complex secret, store it in a file, then
gcloud secrets create ${SECRET_NAME} --data-file=/path/to/my-secret.txt
Cloud SQL
# List instances:
gcloud sql instances list

# Describe instance:
gcloud sql instances describe ${INSTANCE_NAME}

# Connect (starts proxy):
gcloud sql connect ${INSTANCE_NAME} --user=${DB_USER}

# Create user:
gcloud sql users create ${DB_USER} --instance=${INSTANCE_NAME} --password=PASSWORD

# Export data:
gcloud sql export sql ${INSTANCE_NAME} gs://${BUCKET_NAME}/dump.sql.gz --database=${DATABASE_NAME}

# Import data:
gcloud sql import sql ${INSTANCE_NAME} gs://${BUCKET_NAME}/dump.sql.gz --database=${DATABASE_NAME}
IAM (Identity and Access Management)
# Get project IAM policy:
gcloud projects get-iam-policy ${PROJECT_ID}

# Add IAM policy binding:
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member=${MEMBER} --role=${ROLE}

# Remove IAM policy binding:
gcloud projects remove-iam-policy-binding ${PROJECT_ID} --member=${MEMBER} --role=${ROLE}
Params:

MEMBER: user:email, serviceAccount:email, group:email, domain:domain
ROLE: e.g., roles/viewer, roles/storage.objectAdmin
Cloud Run
# Deploy service:
gcloud run deploy ${SERVICE_NAME} --image=gcr.io/${PROJECT_ID}/${IMAGE_NAME} --platform=managed --region=${REGION} --allow-unauthenticated

# List services:
gcloud run services list --platform=managed --region=${REGION}

# Describe service:
gcloud run services describe ${SERVICE_NAME} --platform=managed --region=${REGION}

# Set min-instance to 0 to reduce cost when idle.
# Set min-instances to be >0 to avoid startup delays.
gcloud run services update ${SERVICE_NAME} --min-instances=0 --region=${REGION}

# Replace service with a service.yaml:
#
# apiVersion: serving.knative.dev/v1
# kind: Service
# metadata:
#   name: your-service-name
# spec: ...
gcloud run services replace service.yaml --region=${REGION}

# Delete service:
gcloud run services delete ${SERVICE_NAME} --platform=managed --region=${REGION}
Cloud Logging
# Read log entries:
gcloud logging read "[FILTER]" --limit=10
Example Filters:

resource.type="gce_instance" AND severity>=ERROR
resource.type="cloud_function" AND resource.labels.function_name="my-function"
Cloud Pub/Sub
# List topics:
gcloud pubsub topics list

# Create topic:
gcloud pubsub topics create ${TOPIC_NAME}

# Publish message:
gcloud pubsub topics publish ${TOPIC_NAME} --message "Hello World"

# List subscriptions:
gcloud pubsub subscriptions list

# Create subscription:
gcloud pubsub subscriptions create ${SUB_NAME} --topic ${TOPIC_NAME}

# Pull messages:
gcloud pubsub subscriptions pull ${SUB_NAME} --auto-ack --limit=10
Cloud Asset Inventory
The gcloud asset commands allow you to gain comprehensive insights into your Google Cloud resources and their associated IAM policies. This is crucial for security, compliance, and auditing purposes.

# Export all resource metadata for a project to a Cloud Storage bucket:
gcloud asset export \
    --project=YOUR_PROJECT_ID \
    --output-path="gs://YOUR_BUCKET_NAME/assets-snapshot.json" \
    --content-type=resource

# Export all IAM policies for an organization to a Cloud Storage bucket:**
gcloud asset export \
    --organization=YOUR_ORGANIZATION_ID \
    --output-path="gs://YOUR_BUCKET_NAME/iam-policies-snapshot.json" \
    --content-type=iam-policy

# Export all resource metadata and IAM policies for a folder to BigQuery:
gcloud asset export \
    --folder=YOUR_FOLDER_ID \
    --output-bigquery-table="projects/YOUR_PROJECT_ID/datasets/YOUR_DATASET/tables/your_asset_table" \
    --content-type=resource \
    --content-type=iam-policy \
    --snapshot-time="2024-01-30T00:00:00Z"

# Search for all resources within a project:
gcloud asset search-all-resources \
    --scope=projects/YOUR_PROJECT_ID

# Search for all Compute Engine instances in an organization:
gcloud asset search-all-resources \
    --scope=organizations/YOUR_ORGANIZATION_ID \
    --asset-types="compute.googleapis.com/Instance"

# Search for resources with a specific label in a folder:
gcloud asset search-all-resources \
    --scope=folders/YOUR_FOLDER_ID \
    --filter="labels.environment:production"

# Search for unlabelled resources:
gcloud asset search-all-resources \
    --scope=projects/YOUR_PROJECT_ID \
    --filter="-labels.*"

# Find all IAM policies within a project:
gcloud asset search-all-iam-policies \
    --scope=projects/YOUR_PROJECT_ID

# Find all IAM policies where a specific user has the "Owner" role in an organization:
gcloud asset search-all-iam-policies \
    --scope=organizations/YOUR_ORGANIZATION_ID \
    --query="policy:(roles/owner user:user@example.com)"

# Find all publicly accessible resources (where `allUsers` or `allAuthenticatedUsers` are present in policies) in a folder:
gcloud asset search-all-iam-policies \
    --scope=folders/YOUR_FOLDER_ID \
    --query="policy:(allUsers OR allAuthenticatedUsers)"

# Find IAM policies that contain a specific permission (e.g., `compute.instances.create`):
gcloud asset search-all-iam-policies \
    --scope=organizations/YOUR_ORGANIZATION_ID \
    --query="policy:roles/compute.instanceAdmin"
Output Formatting
# Get JSON output:
gcloud compute instances list --format=json

# Get specific value (e.g., first instance's name):
gcloud compute instances list --format="value(name)" --limit=1

# Get specific values from list into table:
gcloud compute instances list --format="table(name, zone, status)"

# Complex projection (machine type of instances named 'test'):
gcloud compute instances list --filter="name~'^test'" --format='value(machineType)'
Core Concepts
Command Structure: gcloud [GROUP] [SUBGROUP] [COMMAND] [ENTITY] [FLAGS/ARGS]
Example: gcloud compute instances create my-instance --zone=us-central1-a
Configuration: gcloud uses named configurations (default is default). Settings include account, project, region, zone.
Flags: Modify command behavior (e.g., --project, --zone, --format, --quiet).
Positional Arguments: Usually identify the specific resource (e.g., instance name, bucket name).
Help: Use gcloud help or gcloud [COMMAND] --help for detailed information.
Installation & Initialization
Install: Follow official instructions: https://cloud.google.com/sdk/docs/install

Initializaztion:

# Run this first after installation. Logs you in, sets up a default project, region, and zone.
gcloud init

# Re-initialize specific steps:
gcloud init --console-only # Non-interactive
gcloud init --skip-diagnostics
Scripting Tips
Always use --quiet (-q) to avoid interactive prompts.
Use --format=json or --format=yaml for parsing output in scripts.
Use --format='value(field.subfield)' to extract single values directly.
Use --filter to narrow down results server-side before processing.
Check command exit codes ($? in bash) for success (0) or failure (non-zero).
Common Global Flags
--project=PROJECT_ID: Specify the project for this command only.
--quiet or -q: Disable interactive prompts (useful for scripts).
--format=[FORMAT]: Specify output format (json, yaml, text, table, csv, value(.), list).
--filter=[EXPRESSION]: Filter results based on resource attributes (e.g., --filter="status=RUNNING AND zone:us-central1").
--sort-by=[FIELD]: Sort results (e.g., --sort-by=~name for descending name).
--limit=[NUMBER]: Limit the number of results.
--page-size=[NUMBER]: Set the number of results per page.
--verbosity=[LEVEL]: Set log level (debug, info, warning, error, critical, none).
--impersonate-service-account=[SA_EMAIL]: Run command as a service account.
Getting Help
General help: gcloud help
Help for a specific command group (e.g., compute): gcloud compute help
Help for a specific command (e.g., compute instances create): gcloud compute instances create --help
FAQ
How to get the project number of a project id?
gcloud projects describe PROJECT_ID
gcloud projects describe PROJECT_ID --format="value(projectNumber)"
How to get the project number or project id of a GCS bucket?
# To get the project number of a bucket:
gcloud storage buckets describe gs://${BUCKET_NAME} --raw | grep projectNumber

# Then find the project id:
gcloud projects describe PROJECT_ID_OR_NUMBER
How to Check GCP API Usage?
Use this command to list all enabled APIs and services:

gcloud services list
However you can only check which APIs are enabled, gcloud cannot be used to check the actual usage. Instead, go to Cloud Console: https://console.cloud.google.com/apis/dashboard?project=PROJECT_ID

How to get a list of projects that are VPC-SC protected?
VPC-SC resources (AccessPolicy, SevicePerimeter, etc) are org-level.

If a project is in the ServicePerimeterConfig.resources field then the project is protected by VPC-SC.

search-all-resources does NOT return the full content of the resources, e.g. it does not show the configs inside a ServicePerimeter. To check the configs of the resources, use gcloud asset list.

To get a list of projects that are VPC-SC protected:

gcloud asset list --organization="${ORG_ID}$" --content-type='access-policy' --format='json' | jq '[.[] | select(.servicePerimeter) | (.servicePerimeter.spec.resources + .servicePerimeter.status.resources)] | add'
Note that content-type is access-policy instead of resource, and do NOT set asset-types.

