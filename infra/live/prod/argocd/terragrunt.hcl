include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/argocd"
}

dependency "irsa_lb_controller" {
  config_path = "../irsa"
}
