# module 
module "terraform_sample_development" {
  source      = "../module"
  project_id  = local.project_id
  environment = "development"
}
