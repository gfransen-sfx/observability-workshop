# AWS Auth Configuration
provider "aws" {
  region     = lookup(var.aws_region, var.region)
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

# provider "signalfx" {
#   auth_token = var.access_token
#   # api_url    = var.api_url
# }

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  region         = lookup(var.aws_region, var.region)
  environment    = var.environment
}

module "itsi_o11y_cp" {
  source                                           = "./modules/itsi_o11y_cp"
  environment                                      = var.environment
  region                                           = lookup(var.aws_region, var.region)
  vpc_id                                           = module.vpc.vpc_id
  vpc_cidr_block                                   = var.vpc_cidr_block
  public_subnet_ids                                = module.vpc.public_subnet_ids
  key_name                                         = var.key_name
  private_key_path                                 = var.private_key_path
  ami                                              = data.aws_ami.latest-ubuntu.id
  splunk_itsi_inst_type                            = var.splunk_itsi_inst_type
  splunk_itsi_version                              = var.splunk_itsi_version
  splunk_itsi_filename                             = var.splunk_itsi_filename
  splunk_itsi_files_local_path                     = var.splunk_itsi_files_local_path
  splunk_itsi_license_filename                     = var.splunk_itsi_license_filename
  splunk_app_for_content_packs_filename            = var.splunk_app_for_content_packs_filename
  splunk_it_service_intelligence_filename          = var.splunk_it_service_intelligence_filename
  splunk_synthetic_monitoring_add_on_filename      = var.splunk_synthetic_monitoring_add_on_filename
  splunk_infrastructure_monitoring_add_on_filename = var.splunk_infrastructure_monitoring_add_on_filename
}

### Splunk ITSI Outputs ###
output "Splunk_ITSI_Server" {
  value = module.itsi_o11y_cp.*.splunk_itsi_details
}
output "Splunk_ITSI_Password" {
  value = module.itsi_o11y_cp.*.splunk_itsi_password
  # sensitive = true
}
output "Splunk_ITSI_URL" {
  value = module.itsi_o11y_cp.*.splunk_itsi_urls
}