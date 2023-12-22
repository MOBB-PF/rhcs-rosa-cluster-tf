################################
# Pipeline Variables 
################################

variable "env" {
  type        = string
  description = "environment"
  default     = "nonprod"
}

variable "create_account_roles" {
  type        = bool
  description = "environment"
  default     = false
}

################################
# Network Variables
################################

variable "vpc_name" {
  type        = string
  description = "The name of the VPC to create"
}

variable "vpc_cidr" {
  type        = string
  description = "The name of the VPC to create"
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  type        = bool
  description = "enable nat gateway on vpc module"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames on vpc module"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "enable dns support on vpc module"
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

################################
# OCM ACCOUNT
################################

variable "ocm_environment" {
  type    = string
  default = "production"
}

################################
# OCM SHARED
################################

variable "token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "helm_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
  default   = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
  default   = ""
}

variable "AWS_DEFAULT_REGION" {
  type      = string
  sensitive = true
  default   = ""
}

variable "operator_role_prefix" {
  type = string
}

variable "url" {
  type    = string
  default = "https://api.openshift.com"
}

variable "account_role_prefix" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "foster-ocm-rosa"
}

################################
# RHCS CLUSTER
################################

## Optional

variable "private" {
  type        = bool
  description = "is this a private cluster"
  default     = false
}

variable "autoscaling_enabled" {
  type        = bool
  description = "Enables autoscaling."
  default     = true
}

variable "availability_zones" {
  type        = list(string)
  description = "azs on vpc module"
  default     = ["ap-southeast-2a"]
}

variable "aws_private_link" {
  type        = bool
  description = "Provides private connectivity between VPCs, AWS services, and your on-premises networks, without exposing your traffic to the public internet."
  default     = "false"
}

variable "channel_group" {
  type        = string
  description = "Name of the channel group where you select the OpenShift cluster version, for example 'stable'."
  default     = "stable"
}

variable "compute_machine_type" {
  type        = string
  description = "Identifies the machine type used by the compute nodes, for example r5.xlarge. Use the ocm_machine_types data source to find the possible values."
  default     = "r5.xlarge"
}

variable "default_mp_labels" {
  type        = map(string)
  description = "This value is the default machine pool labels. Format should be a comma-separated list. This list overwrites any modifications made to Node labels on an ongoing basis."
  default     = {}
}

variable "destroy_timeout" {
  type        = number
  description = "This value sets the maximum duration in minutes to allow for destroying resources. Default value is 60 minutes."
  default     = 60
}

variable "disable_scp_checks" {
  type        = bool
  description = "Enables you to monitor your own projects in isolation from Red Hat Site Reliability Engineer (SRE) platform metrics."
  default     = "false"
}

variable "disable_waiting_in_destroy" {
  type        = bool
  description = "Disable addressing cluster state in the destroy resource. Default value is false."
  default     = false
}

variable "disable_workload_monitoring" {
  type        = bool
  description = "Enables you to monitor your own projects in isolation from Red Hat Site Reliability Engineer (SRE) platform metrics."
  default     = false
}

variable "ec2_metadata_http_tokens" {
  type        = string
  description = "This value determines which EC2 metadata mode to use for metadata service interaction options for EC2 instances can be optional or required. This feature is available from OpenShift version 4.11.0 and newer."
  default     = "required"
}

variable "etcd_encryption" {
  type        = bool
  description = "Encrypt etcd data."
  default     = false
}

variable "external_id" {
  type        = string
  description = "Unique external identifier of the cluster."
  default     = null
}

variable "fips" {
  type        = bool
  description = "Create cluster that uses FIPS Validated / Modules in Process cryptographic libraries."
  default     = false
}

variable "host_prefix" {
  type        = number
  description = "Length of the prefix of the subnet assigned to each node."
  default     = 23
}

variable "kms_key_arn" {
  type        = string
  description = "The key ARN is the Amazon Resource Name (ARN) of a AWS Key Management Service (KMS) Key. It is a unique, fully qualified identifier for the AWS KMS Key. A key ARN includes the AWS account, Region, and the key ID."
  default     = null
}

variable "max_replicas" {
  type        = string
  description = "Maximum replicas."
  default     = null
}

variable "min_replicas" {
  type        = string
  description = "Minimum replicas."
  default     = null
}

variable "multi_az" {
  type        = bool
  description = "Indicates if the cluster should be deployed to multiple availability zones. Default value is 'false'."
  default     = false
}

variable "pod_cidr" {
  type        = string
  description = "Block of IP addresses for pods."
  default     = "10.128.0.0/14"
}

variable "proxy" {
  type        = map(string)
  description = "proxy (see below for nested schema)"
  default     = null
}

variable "replicas" {
  type        = string
  description = "Number of worker nodes to provision. Single zone clusters need at least 2 nodes, multizone clusters need at least 3 nodes."
  default     = null
}

variable "service_cidr" {
  type        = string
  description = "Block of IP addresses for services."
  default     = "172.30.0.0/16"
}

variable "ocp_version" {
  type        = string
  description = "Desired version of OpenShift for the cluster, for example 'openshift-v4.1.0'. If version is greater than the currently running version, an upgrade will be scheduled."
  default     = "4.13.4"
}

variable "path" {
  description = "(Optional) The arn path for the account/operator roles as well as their policies."
  type        = string
  default     = null
}

################################
# OCM OIDC
################################

variable "managed" {
  description = "Indicates whether it is a Red Hat managed or unmanaged (Customer hosted) OIDC Configuration"
  type        = bool
  default     = true
}

variable "installer_role_arn" {
  description = "STS Role ARN with get secrets permission, relevant only for unmanaged OIDC config"
  type        = string
  default     = null
}

################################
# Machine Pools object
################################
variable "machine_pools" {
  default = {}
  type    = map(any)
}

################################
# idp object
################################
variable "idp" {
  default = {}
  type    = map(any)
}

################################
# tags object
################################
variable "tags" {
  type    = map(string)
  default = {}
}

################################
# cluster seed
################################

variable "seed" {
  type        = map(string)
  description = "Create a secret for the admin password, generate and store secret, and deploy a helm chart to cluster."
  default = {

  }
}

################################
# customer
################################

variable "customers" {
  type        = map(any)
  description = "Create a secret for the admin password, generate and store secret, and deploy a helm chart to cluster."
  default     = {}
}

variable "customer_chart" {
  type        = map(string)
  description = "Create a secret for the admin password, generate and store secret, and deploy a helm chart to cluster."
  default     = {}
}

################################
# custom_domain
################################

variable "custom_domains" {
  type        = map(any)
  description = "map of custom domains to impliment."
  default     = {}
}

variable "route53_records" {
  type        = map(any)
  description = "map of custom domains to impliment."
  default     = {}
}

variable "oidc" {
  type        = string
  description = "OIDC"
  default     = "270aekr3qab4nqe0l03smel47hj8sq41"
}
