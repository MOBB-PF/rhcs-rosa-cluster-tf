locals {
  sts_roles = {
    role_arn         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-Installer-Role",
    support_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-Support-Role",
    instance_iam_roles = {
      master_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-ControlPlane-Role",
      worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.account_role_prefix}-Worker-Role"
    },
    operator_role_prefix = var.operator_role_prefix
    #oidc_config_id       = module.oidc_config.id
  }
}

module "create_account_roles" {
  count   = var.create_account_roles == true ? 1 : 0
  source  = "terraform-redhat/rosa-sts/aws"
  version = ">=0.0.14"

  create_operator_roles = false
  create_oidc_provider  = false
  create_account_roles  = true

  all_versions           = data.rhcs_versions.all
  account_role_prefix    = var.account_role_prefix
  ocm_environment        = var.ocm_environment
  rosa_openshift_version = ""
  account_role_policies  = data.rhcs_policies.all_policies.account_role_policies
  operator_role_policies = data.rhcs_policies.all_policies.operator_role_policies
  path                   = var.path
}

resource "rhcs_cluster_rosa_classic" "rosa_sts_cluster" {

  name                        = var.cluster_name
  cloud_region                = var.AWS_DEFAULT_REGION
  aws_account_id              = data.aws_caller_identity.current.account_id
  version                     = var.ocp_version
  sts                         = local.sts_roles
  machine_cidr                = module.vpc.vpc_cidr_block
  aws_private_link            = var.aws_private_link
  aws_subnet_ids              = var.private == true ? module.vpc.private_subnets : concat(module.vpc.private_subnets, module.vpc.public_subnets)
  availability_zones          = var.availability_zones
  multi_az                    = var.multi_az
  pod_cidr                    = var.pod_cidr
  service_cidr                = var.service_cidr
  channel_group               = var.channel_group
  compute_machine_type        = var.compute_machine_type
  default_mp_labels           = var.default_mp_labels
  destroy_timeout             = var.destroy_timeout
  disable_scp_checks          = var.disable_scp_checks
  disable_waiting_in_destroy  = var.disable_waiting_in_destroy
  disable_workload_monitoring = var.disable_workload_monitoring
  fips                        = var.fips
  host_prefix                 = var.host_prefix
  etcd_encryption             = var.etcd_encryption
  autoscaling_enabled         = var.autoscaling_enabled
  ec2_metadata_http_tokens    = var.ec2_metadata_http_tokens
  external_id                 = var.external_id
  kms_key_arn                 = var.kms_key_arn
  max_replicas                = var.max_replicas
  min_replicas                = var.min_replicas
  replicas                    = var.replicas
  proxy                       = var.proxy
  tags                        = var.tags
  private                     = var.private
  properties = {
    rosa_creator_arn = data.aws_caller_identity.current.arn
  }
  depends_on = [
    module.vpc,
    resource.time_sleep.wait_for_role_propagation
  ]
}

resource "rhcs_cluster_wait" "rosa_cluster" {
  cluster = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
  timeout = 60
}

module "operator_roles" {
  source  = "terraform-redhat/rosa-sts/aws"
  version = ">=0.0.14"

  create_operator_roles = true
  create_oidc_provider  = true
  create_account_roles  = false

  cluster_id                  = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
  rh_oidc_provider_thumbprint = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.thumbprint
  rh_oidc_provider_url        = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url
  operator_roles_properties   = data.rhcs_rosa_operator_roles.operator_roles.operator_iam_roles
  tags                        = var.tags
}

resource "time_sleep" "wait_for_role_propagation" {
  create_duration = "60s"
  depends_on = [
    module.create_account_roles
  ]
}

module "oidc_config" {
  token                = var.token
  url                  = var.url
  source               = "./modules/oidc-provider-modules"
  managed              = true
  operator_role_prefix = var.operator_role_prefix
  account_role_prefix  = var.account_role_prefix
  tags                 = var.tags
  cloud_region         = var.AWS_DEFAULT_REGION

  depends_on = [
    resource.rhcs_cluster_wait.rosa_cluster
  ]
}
