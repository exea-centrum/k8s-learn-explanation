Azure CLI (az)
Note: Replace placeholders like [RESOURCE_GROUP], [VM_NAME], [LOCATION], etc., with your actual values. Many commands inherit the location from the resource group. You often need to be logged in (az login) first.

Core Concepts (Login, Accounts, Resource Groups)
Login:
Interactive:
az login
Using Device Code (for environments without browser):
az login --use-device-code
Account/Subscription:
List available subscriptions:
az account list --output table
Show current subscription:
az account show --output table
Set active subscription:
az account set --subscription "[SUBSCRIPTION_ID_OR_NAME]"
Resource Groups:
List resource groups:
az group list --output table
Create resource group:
az group create --name [RESOURCE_GROUP] --location [LOCATION]
(e.g., eastus, westus2, westeurope)
Show resource group details:
az group show --name [RESOURCE_GROUP]
Delete resource group (and all resources within it!):
az group delete --name [RESOURCE_GROUP] --yes --no-wait
Virtual Machines (VMs)
List VMs in a resource group:
az vm list --resource-group [RESOURCE_GROUP] --output table
Show VM details:
az vm show --resource-group [RESOURCE_GROUP] --name [VM_NAME] --show-details
Create Linux VM:
az vm create \
  --resource-group [RESOURCE_GROUP] \
  --name [VM_NAME] \
  --image UbuntuLTS \
  --size Standard_DS1_v2 \
  --admin-username [ADMIN_USER] \
  --generate-ssh-keys
Create Windows VM:
az vm create \
  --resource-group [RESOURCE_GROUP] \
  --name [VM_NAME] \
  --image Win2019Datacenter \
  --size Standard_DS1_v2 \
  --admin-username [ADMIN_USER] \
  --admin-password '[COMPLEX_PASSWORD]'
Stop VM (Keeps resources provisioned):
az vm stop --resource-group [RESOURCE_GROUP] --name [VM_NAME]
Start VM:
az vm start --resource-group [RESOURCE_GROUP] --name [VM_NAME]
Deallocate VM (Stops compute billing):
az vm deallocate --resource-group [RESOURCE_GROUP] --name [VM_NAME]
Restart VM:
az vm restart --resource-group [RESOURCE_GROUP] --name [VM_NAME]
Delete VM (Doesn't delete disks/NICs by default):
az vm delete --resource-group [RESOURCE_GROUP] --name [VM_NAME] --yes
SSH into Linux VM (requires SSH client):
# Get public IP first if needed
# az vm show -d --resource-group [RESOURCE_GROUP] --name [VM_NAME] --query publicIps -o tsv
# ssh [ADMIN_USER]@[PUBLIC_IP_ADDRESS]

# Or use the az ssh command (may require an extension)
az ssh vm --resource-group [RESOURCE_GROUP] --name [VM_NAME] --local-user [LOCAL_MACHINE_USER]
Azure Kubernetes Service (AKS)
List AKS clusters:
az aks list --resource-group [RESOURCE_GROUP] --output table
Show AKS cluster details:
az aks show --resource-group [RESOURCE_GROUP] --name [CLUSTER_NAME]
Create AKS cluster:
az aks create \
  --resource-group [RESOURCE_GROUP] \
  --name [CLUSTER_NAME] \
  --node-count 1 \
  --enable-addons monitoring \
  --generate-ssh-keys
Get credentials (configures kubectl):
az aks get-credentials --resource-group [RESOURCE_GROUP] --name [CLUSTER_NAME] --overwrite-existing
(Now use kubectl get nodes, kubectl get pods, etc.)
Scale AKS node pool:
az aks scale --resource-group [RESOURCE_GROUP] --name [CLUSTER_NAME] --node-count 3
Delete AKS cluster:
az aks delete --resource-group [RESOURCE_GROUP] --name [CLUSTER_NAME] --yes --no-wait
Azure Storage (Blobs)
Note: Requires a Storage Account. Many commands need --account-name [ACCOUNT_NAME]. Use --auth-mode login for Azure AD authentication (preferred) or provide --account-key or --connection-string.

List Storage Accounts:
az storage account list --resource-group [RESOURCE_GROUP] --output table
Create Storage Account:
az storage account create \
  --name [ACCOUNT_NAME] \
  --resource-group [RESOURCE_GROUP] \
  --location [LOCATION] \
  --sku Standard_LRS \
  --kind StorageV2
List Containers (like buckets):
az storage container list --account-name [ACCOUNT_NAME] --auth-mode login --output table
Create Container:
az storage container create --account-name [ACCOUNT_NAME] --name [CONTAINER_NAME] --auth-mode login
List Blobs (objects) in Container:
az storage blob list --account-name [ACCOUNT_NAME] --container-name [CONTAINER_NAME] --auth-mode login --output table
Upload File to Blob:
az storage blob upload \
  --account-name [ACCOUNT_NAME] \
  --container-name [CONTAINER_NAME] \
  --name [BLOB_NAME] \
  --file /path/to/local/file \
  --auth-mode login
Download Blob to File:
az storage blob download \
  --account-name [ACCOUNT_NAME] \
  --container-name [CONTAINER_NAME] \
  --name [BLOB_NAME] \
  --file /path/to/local/destination \
  --auth-mode login
Delete Blob:
az storage blob delete --account-name [ACCOUNT_NAME] --container-name [CONTAINER_NAME] --name [BLOB_NAME] --auth-mode login
Delete Container:
az storage container delete --account-name [ACCOUNT_NAME] --name [CONTAINER_NAME] --auth-mode login
Azure SQL Database
Note: Requires an Azure SQL Server.

List SQL Servers:
az sql server list --resource-group [RESOURCE_GROUP] --output table
List Databases on a Server:
az sql db list --resource-group [RESOURCE_GROUP] --server [SERVER_NAME] --output table
Show Database details:
az sql db show --resource-group [RESOURCE_GROUP] --server [SERVER_NAME] --name [DB_NAME]
Create Database:
az sql db create \
  --resource-group [RESOURCE_GROUP] \
  --server [SERVER_NAME] \
  --name [DB_NAME] \
  --edition Basic # Or Standard, Premium, etc.
Set Firewall Rule (to allow access from your IP):
# Find your public IP (e.g., using curl ifconfig.me)
az sql server firewall-rule create \
  --resource-group [RESOURCE_GROUP] \
  --server [SERVER_NAME] \
  --name AllowMyIP \
  --start-ip-address [YOUR_PUBLIC_IP] \
  --end-ip-address [YOUR_PUBLIC_IP]
Delete Database:
az sql db delete --resource-group [RESOURCE_GROUP] --server [SERVER_NAME] --name [DB_NAME] --yes
Export Database (to BACPAC in Azure Storage):
az sql db export \
  --resource-group [RESOURCE_GROUP] \
  --server [SERVER_NAME] \
  --database [DB_NAME] \
  --admin-user [SQL_ADMIN_USER] \
  --admin-password '[SQL_ADMIN_PASSWORD]' \
  --storage-key-type StorageAccessKey \
  --storage-key "[STORAGE_ACCOUNT_KEY]" \
  --storage-uri "https://[STORAGE_ACCOUNT_NAME].blob.core.windows.net/[CONTAINER_NAME]/[FILENAME.bacpac]"
Import Database (from BACPAC in Azure Storage):
az sql db import \
  --resource-group [RESOURCE_GROUP] \
  --server [SERVER_NAME] \
  --database [DB_NAME] \
  --admin-user [SQL_ADMIN_USER] \
  --admin-password '[SQL_ADMIN_PASSWORD]' \
  --storage-key-type StorageAccessKey \
  --storage-key "[STORAGE_ACCOUNT_KEY]" \
  --storage-uri "https://[STORAGE_ACCOUNT_NAME].blob.core.windows.net/[CONTAINER_NAME]/[FILENAME.bacpac]" \
  --edition Basic # Target edition
RBAC (Role-Based Access Control)
List Role Definitions (available roles):
az role definition list --output table --query "[].{Name:roleName, Id:name, Type:roleType}" # Basic info
az role definition list --name "[ROLE_NAME]" # Find specific role like "Reader", "Contributor"
Assign Role to User/Service Principal:
# Get Principal ID (Object ID) of the user or service principal
# az ad user show --id user@domain.com --query id -o tsv
# az ad sp list --display-name <sp_name> --query "[].id" -o tsv

az role assignment create \
  --assignee [PRINCIPAL_ID] \
  --role "[ROLE_NAME_OR_ID]" \
  --scope "/subscriptions/[SUBSCRIPTION_ID]/resourceGroups/[RESOURCE_GROUP]" # Or other scopes like subscription, resource
List Role Assignments (at a scope):
az role assignment list --resource-group [RESOURCE_GROUP] --output table # For a resource group
az role assignment list --assignee [PRINCIPAL_ID] --output table # For a specific principal
Remove Role Assignment:
az role assignment delete \
  --assignee [PRINCIPAL_ID] \
  --role "[ROLE_NAME_OR_ID]" \
  --scope "/subscriptions/[SUBSCRIPTION_ID]/resourceGroups/[RESOURCE_GROUP]"
App Service (Web Apps)
Note: Requires an App Service Plan.

List App Service Plans:
az appservice plan list --resource-group [RESOURCE_GROUP] --output table
Create App Service Plan:
az appservice plan create \
  --name [PLAN_NAME] \
  --resource-group [RESOURCE_GROUP] \
  --sku F1 # Free tier, others: B1, S1, P1V2 etc.
  # Use --is-linux for Linux plans
List Web Apps:
az webapp list --resource-group [RESOURCE_GROUP] --output table
Create Web App (Linux example):
az webapp create \
  --resource-group [RESOURCE_GROUP] \
  --plan [PLAN_NAME] \
  --name [WEBAPP_NAME] \
  --runtime "PYTHON:3.9" # Other examples: "NODE:16-lts", "DOTNET:6.0", "PHP:8.0"
Deploy Code (Zip deploy example):
# Ensure you are in the directory with your zipped code or the code itself
az webapp deploy \
  --resource-group [RESOURCE_GROUP] \
  --name [WEBAPP_NAME] \
  --src-path [/path/to/your/app.zip] # Or point to a folder
  --type zip # Or other types like git, war, jar
Browse Web App:
az webapp browse --resource-group [RESOURCE_GROUP] --name [WEBAPP_NAME]
Delete Web App:
az webapp delete --resource-group [RESOURCE_GROUP] --name [WEBAPP_NAME]
Azure Monitor (Activity Log)
List Activity Log entries for a resource group:
az monitor activity-log list --resource-group [RESOURCE_GROUP] --output table --max-events 10
Filter Activity Log (example: by caller):
az monitor activity-log list --resource-group [RESOURCE_GROUP] --caller "user@yourdomain.com" --max-events 10
Filter Activity Log (example: by status):
az monitor activity-log list --resource-group [RESOURCE_GROUP] --status Failed --max-events 10
Service Bus (Messaging)
Note: Requires a Service Bus Namespace. Roles like "Azure Service Bus Data Sender/Receiver" are often needed on the namespace for sending/receiving.

List Service Bus Namespaces:
az servicebus namespace list --resource-group [RESOURCE_GROUP] --output table
Create Service Bus Namespace:
az servicebus namespace create \
  --resource-group [RESOURCE_GROUP] \
  --name [NAMESPACE_NAME] \
  --location [LOCATION] \
  --sku Basic # Or Standard, Premium
List Topics:
az servicebus topic list --resource-group [RESOURCE_GROUP] --namespace-name [NAMESPACE_NAME] --output table
Create Topic:
az servicebus topic create \
  --resource-group [RESOURCE_GROUP] \
  --namespace-name [NAMESPACE_NAME] \
  --name [TOPIC_NAME]
Send Message to Topic:
az servicebus topic message send \
  --resource-group [RESOURCE_GROUP] \
  --namespace-name [NAMESPACE_NAME] \
  --topic-name [TOPIC_NAME] \
  --message-body "Your message content here"
List Subscriptions for a Topic:
az servicebus topic subscription list \
  --resource-group [RESOURCE_GROUP] \
  --namespace-name [NAMESPACE_NAME] \
  --topic-name [TOPIC_NAME] \
  --output table
Create Subscription for a Topic:
az servicebus topic subscription create \
  --resource-group [RESOURCE_GROUP] \
  --namespace-name [NAMESPACE_NAME] \
  --topic-name [TOPIC_NAME] \
  --name [SUBSCRIPTION_NAME]
(Receiving messages is typically done via SDKs, not directly via a simple CLI command for typical workflows.)