Terraform / OpenTofu
This is a cheatsheet of Terraform and OpenTofu configurations.

For HCL syntax, check out Cheatsheet - HCL page.
For Terraform CLI and Tofu CLI, check out Cheatsheet - Terraform CLI / Tofu CLI page.
Terraform Blocks
Hierarchy:

terraform => provider => resource
                      => data
Resource: Generate; e.g. generate a local file resource "local_file" "foo" {}
Data Source: Read; e.g. read a local file data "local_file" "foo" {} , then content can be referenced by data.local_file.foo.content
3 types of values:

variable: input variable (like the arguments of a func)
output: output variable (like the return value of a func)
locals: local values (like temp / local vars in a func)
Terraform
Top level configs, e.g. required_providers, required_version, etc.

terraform {
  required_version = "1.5.7"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}
Providers
providers = terraform plugins; Each provider adds a set of resource types and/or data sources that Terraform can manage.

The Terraform Registry is the main directory of publicly available Terraform providers

official: hashicorp

source address: registry.terraform.io/hashicorp/http
default registry host: registry.terraform.io
namespace: hashicorp
type: http
For example:

provider "aws" {
  region = "us-east-1"
}
required provider:

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=x.y.0"
    }
  }
  ...
}

provider "google" {
  ...
}
hashicorp/google, its preferred local name is google

if you do not use the preferred local name, must use a meta-argument provider = <local name> to specify the provider in data and resource etc.

version:

>= minimum version
~> only allowing the rightmost component of a version to increment
version = "~> 1.0.4" allow only patch releases within a specific minor release:

Built-in Providers do not need to be declared in required_providers

Resource
Each resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records.

Format:

resource <type> <local_name> {}
For example:

resource "aws_instance" "example" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags = {
    Name = "MyExampleInstance"
  }
}
Most arguments in this section depend on the resource type

Each resource type is implemented by a provider; By convention, resource type names start with their provider's preferred local name.

Variable
Input values for your Terraform configuration. Defined in variables.tf (or inline).

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t2.micro"
}
To use: var.instance_type To set: terraform apply -var="instance_type=t2.small" or terraform.tfvars file.

Data
Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions. Read from data_source and export the result under local_name

data <data_source> <local_name> {

}
For example:

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
Output
Values that are exported by a Terraform configuration. Defined in outputs.tf.

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.example.id
}
Output value can be referenced by module.<MODULE NAME>.<OUTPUT NAME>, e.g. module.web_server.instance_ip_addr.

Check
The check block can validate your infrastructure outside the usual resource lifecycle.

Import blocks
available in >=1.5

Module
A Module is a collection of .tf and/or .tf.json files kept together in a directory.

Reusable, encapsulated configurations.

module "vpc" {
  source = "./modules/vpc" # Local path
  # source = "terraform-aws-modules/vpc/aws" # Registry module
  cidr_block = "10.0.0.0/16"
  # ... other module inputs
}
State File
terraform.tfstate: A JSON file that maps real-world resources to your configuration. Crucial for Terraform's operation. Do not edit manually. Store remotely for team collaboration (e.g., S3, Azure Blob, GCS).

terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "path/to/my/key.tfstate"
    region = "us-east-1"
  }
}
Advanced Features
count: Creates multiple instances of a resource based on a numerical count.

resource "aws_instance" "app_server" {
  count = 3
  ami = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
  tags = {
    Name = "AppServer-${count.index}"
  }
}
for_each: Creates multiple instances of a resource based on a map or set of strings, providing more stable identifiers.

variable "regions" {
  type = map(string)
  default = {
    "us-east-1" = "ami-0abcdef1234567890"
    "us-west-2" = "ami-0fedcba9876543210"
  }
}

resource "aws_instance" "region_instance" {
  for_each = var.regions
  ami           = each.value
  instance_type = "t2.micro"
  tags = {
    Name    = "Instance-${each.key}"
    Region  = each.key
  }
}
depends_on: Explicitly specifies resource dependencies when Terraform cannot infer them.

resource "aws_instance" "web" {
  # ...
  depends_on = [
    aws_db_instance.main
  ]
}
Tainting: terraform taint [resource_address] marks a resource for recreation on the next apply.

Untainting: terraform untaint [resource_address] removes a tainting mark.

Import: terraform import [resource_address] [resource_id] imports existing infrastructure into Terraform state.

Functions
Terraform provides many built-in functions for manipulating data.

concat(list1, list2)
merge(map1, map2)
lookup(map, key, [default])
file(path)
length(collection)
join(separator, list)
split(separator, string)
lower(string), upper(string)
cidrsubnet(prefix, newbits, netnum)
Registries
When HashiCorp changed its license from the open-source Mozilla Public License to the more restrictive Business Source License, it also put the future of the Terraform Registry under the same license. For OpenTofu to be a viable long-term solution, it needed an independent source for providers and modules that would remain free and open.

Terraform Registry: https://registry.terraform.io/
OpenTofu Registry: https://search.opentofu.org
Providers
Built-in providers:

hashicorp/local
hashicorp/http
hashicorp/tls
hashicorp/random
Public Cloud providers:

hashicorp/aws
hashicorp/google
hashicorp/azurerm
aliyun/alicloud
oracle/oci
Kubernetes / container / VM providers:

hashicorp/kubernetes
kreuzwerker/docker
vmware/nsxt (for NSX-T virtualization platform)

Terraform CLI / OpenTofu CLI
Terraform is an Infrastructure as Code (IaC) tool that lets you define and provision infrastructure using HCL (HashiCorp Configuration Language).

For Terraform and Tofu Configurations, check out Cheatsheet - Terraform page.

1. Initialize Working Directory (terraform init)
This command prepares your working directory for other Terraform operations. It downloads necessary provider plugins and modules, and sets up the backend for state storage.

Purpose: Download providers and modules, configure backend.
Syntax: terraform init [options]
Key Options:
-upgrade: Upgrade modules and provider plugins to their newest available versions.
-backend=false: Do not configure a backend for state storage.
-reconfigure: Forget any existing backend configuration and re-initialize it.
-input=false: Disable interactive prompts for input.
Example:
terraform init             # Initialize the current directory
terraform init -upgrade    # Initialize and upgrade providers/modules
2. Generate Execution Plan (terraform plan)
This command creates an execution plan, showing exactly what Terraform will do to achieve the desired state defined in your configuration files. It does not make any changes to real infrastructure.

Purpose: Preview changes before applying them.
Syntax: terraform plan [options]
Key Options:
-out=tfplan: Save the generated plan to a file for later execution with terraform apply.
-var 'key=value': Set a specific input variable.
-var-file=file.tfvars: Load variable definitions from a .tfvars file.
-destroy: Create a plan to destroy all resources.
-refresh-only: Only update the state from the remote system without proposing configuration changes.
Example:
terraform plan                                    # Show a plan
terraform plan -out=my_app.tfplan                 # Save plan to a file
terraform plan -var 'region=us-west-2'            # Plan with a specific variable
terraform plan -var-file=prod.tfvars              # Plan using a variable file
3. Apply Changes (terraform apply)
This command executes the actions proposed in a Terraform plan to provision or modify infrastructure. It will prompt for confirmation unless -auto-approve is used.

Purpose: Create, update, or delete infrastructure resources.
Syntax: terraform apply [options] [planfile]
Key Options:
-auto-approve: Skip interactive approval of the plan. Use with caution in production.
-var 'key=value': Set a specific input variable.
-var-file=file.tfvars: Load variable definitions from a .tfvars file.
Example:
terraform apply                          # Apply changes (requires confirmation)
terraform apply my_app.tfplan            # Apply a previously saved plan
terraform apply -auto-approve            # Apply changes without confirmation
4. Destroy Infrastructure (terraform destroy)
This command tears down all resources managed by the current Terraform configuration. Use with extreme caution, as it permanently deletes resources. It will prompt for confirmation unless -auto-approve is used.

Purpose: Decommission all managed infrastructure.
Syntax: terraform destroy [options]
Key Options:
-auto-approve: Skip interactive approval.
-var 'key=value': Set a specific input variable.
-var-file=file.tfvars: Load variable definitions from a .tfvars file.
Example:
terraform destroy                   # Destroy resources (requires confirmation)
terraform destroy -auto-approve     # Destroy without confirmation
5. State Management (terraform state)
The terraform state command family allows you to inspect and modify the Terraform state file, which is a critical component mapping your configuration to real-world resources.

terraform state list
Purpose: List all resources currently tracked in the state file.
Example: terraform state list
terraform state show <address>
Purpose: Display the attributes of a specific resource instance from the state file.
Example: terraform state show aws_instance.web
terraform state mv <source_address> <destination_address>
Purpose: Move a resource or multiple resource instances to a new address. Useful for refactoring your configuration.
Example: terraform state mv 'aws_instance.old_name' 'aws_instance.new_name'
terraform state rm <address>
Purpose: Remove a resource from the state file. This does not destroy the actual resource in the cloud, only removes Terraform's management of it.
Example: terraform state rm 'aws_instance.unmanaged_instance'
terraform state replace-provider <old_provider_address> <new_provider_address> (Terraform >= 1.7)
Purpose: Safely replace all references to a given provider in the state. Useful when migrating providers (e.g., from HashiCorp's to OpenTofu's registry mirror).
Example: terraform state replace-provider 'registry.terraform.io/hashicorp/aws' 'registry.opentofu.org/hashicorp/aws'
6. Workspace Management (terraform workspace)
Workspaces allow you to manage multiple distinct states for a single Terraform configuration. This is often used for environments like dev, staging, prod.

terraform workspace list
Purpose: List all existing workspaces.
Example: terraform workspace list
terraform workspace show
Purpose: Display the name of the current workspace.
Example: terraform workspace show
terraform workspace new <name>
Purpose: Create a new workspace and switch to it.
Example: terraform workspace new dev
terraform workspace select <name>
Purpose: Switch to an existing workspace.
Example: terraform workspace select prod
terraform workspace delete <name>
Purpose: Delete an empty workspace.
Example: terraform workspace delete old_test_env
7. Validation & Formatting
Commands for maintaining code quality and correctness.

terraform validate
Purpose: Check configuration files for syntax validity, consistent argument types, and other internal consistency issues.
Example: terraform validate
terraform fmt [path]
Purpose: Rewrite configuration files to a canonical format, improving readability and consistency.
Key Options:
-check: Check if files are formatted, but do not rewrite them.
-diff: Display differences between current and canonical format.
-recursive: Recurse into subdirectories.
Example:
terraform fmt              # Format all .tf files in current directory
terraform fmt -recursive   # Format files in current and subdirectories
terraform fmt -check -diff # Check and show diff without applying
8. Inspecting Configuration & Providers
Helpful commands for understanding your configuration and the providers it uses.

terraform graph
Purpose: Generate a visual graph of your Terraform resources and their dependencies.
Example: terraform graph | dot -Tpng > graph.png (Requires graphviz to be installed for PNG output)
terraform providers schema -json
Purpose: Print the full schema of all providers used in the current configuration, in JSON format.
Example: terraform providers schema -json | jq . (Requires jq for pretty printing)
terraform console
Purpose: Open an interactive console for evaluating expressions defined in your configuration.
Example:
terraform console
> var.region
"us-east-1"
> join("-", ["prefix", "suffix"])
"prefix-suffix"
9. General Utility
terraform version
Purpose: Print the Terraform CLI version and the versions of installed providers.
Example: terraform version
terraform output [name]
Purpose: Display output values from the state file.
Key Options:
-json: Output in JSON format.
-raw: Output a single value without formatting.
Example:
terraform output                    # List all outputs
terraform output instance_ip        # Show a specific output
terraform output -json              # Show all outputs as JSON
terraform refresh
Purpose: Update the state file with the real-world infrastructure's current attributes. (This is implicitly run by plan and apply by default).
Example: terraform refresh
OpenTofu CLI (tofu)
The OpenTofu CLI is designed to be a drop-in replacement for the Terraform CLI (up to the point of the fork).

All commands, options, and syntax shown above generally apply directly to tofu.
The primary difference lies in the default provider registry: OpenTofu uses registry.opentofu.org, whereas Terraform uses registry.terraform.io. You might need to adjust your required_providers blocks or use tofu state replace-provider when migrating existing configurations.
Example with OpenTofu:

# main.tf (for OpenTofu)
terraform { # Or tofu if supported by a future version
  required_providers {
    aws = {
      source  = "registry.opentofu.org/hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# ... rest of your configuration
Then, you would run:

tofu init
tofu plan
tofu apply