# Creating a AWS secret

resource "aws_secretsmanager_secret" "secret" {
  count                   = var.seed.deploy == "true" ? 1 : 0
  name                    = "${var.cluster_name}-${var.env}-credentials"
  recovery_window_in_days = 0
  depends_on = [
    resource.rhcs_cluster_wait.rosa_cluster
  ]
}

# Creating a AWS secret versions

resource "aws_secretsmanager_secret_version" "sversion" {
  count         = var.seed.deploy == "true" ? 1 : 0
  secret_id     = aws_secretsmanager_secret.secret[0].id
  secret_string = <<EOF
   {
    "user": "cluster-admin",
    "password": "initial"
   }
EOF
}

# Generate accounts and store password and deliver helm chart.

resource "null_resource" "seed" {
  count = var.seed.deploy == "true" ? 1 : 0
  provisioner "local-exec" {
    command = "scripts/seed.sh >> output_seed.log 2>&1"
    environment = {
      secret             = "${var.cluster_name}-${var.env}-credentials"
      token              = var.token
      cluster            = var.cluster_name
      secret_id          = aws_secretsmanager_secret.secret[0].id
      helm_token         = var.helm_token
      helm_repo          = var.seed.helm_repo
      helm_chart         = var.seed.helm_chart
      helm_chart_version = var.seed.helm_chart_version
    }
  }
}

# Customer onboarding of helm chart.

resource "null_resource" "customer" {
  for_each = var.customers
  provisioner "local-exec" {
    command = "scripts/customers.sh >> output_customers.log 2>&1"
    environment = {
      secret        = "${var.cluster_name}-${var.env}-credentials"
      wait_on       = null_resource.seed[0].id
      helm_token    = var.helm_token
      customer_name = try(each.value.name, null)
      customer_repo = try(each.value.git_repository, null)
    }
  }
}
