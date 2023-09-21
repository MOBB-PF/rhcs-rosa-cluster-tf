resource "rhcs_identity_provider" "identity_provider" {
  for_each = var.idp
  # defaults
  name    = each.value.name
  cluster = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
  # other
  github         = try(each.value.github, null)
  gitlab         = try(each.value.gitlab, null)
  google         = try(each.value.google, null)
  htpasswd       = try(each.value.htpasswd, null)
  ldap           = try(each.value.ldap, null)
  mapping_method = try(each.value.mapping_method, null)
  openid         = try(each.value.openid, null)
  depends_on = [
    resource.rhcs_cluster_rosa_classic.rosa_sts_cluster
  ]
}
