locals {
  business_name = "mi-dsp"
  application_name = "spark-k8s"
  env_code = "dev"
  subnet_name = "${var.company_name}-${var.business_name}-${var.application_name}-${var.region_code}-${var.env_code}"
  subnet_01 = "${var.application_name}-${var.region_code}-${var.env_code}-node-subnet"
}

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 4.0"

    project_id   = var.gcp_project
    network_name = local.subnet_name
    routing_mode = "REGIONAL"

    subnets = [
        {
            subnet_name           = local.subnet_01
            subnet_ip             = "10.40.32.0/24"
            subnet_region         = var.gcp_region
            subnet_flow_logs      = "true"
            subnet_flow_logs_interval = "INTERVAL_10_MIN"
            subnet_flow_logs_sampling = 0.7
            subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
            description           = "${var.application_name}-node-subnet"
        },
    ]
    secondary_ranges = {
      (local.subnet_01) = [
        {
          range_name     = "${var.application_name}-${var.region_code}-${var.env_code}-pod-subnet"
          ip_cidr_range  = "10.40.48.0/20"
        },
        {
          range_name     = "${var.application_name}-${var.region_code}-${var.env_code}-service-subnet"
          ip_cidr_range  = "10.40.64.0/20"
        },
      ] 
    }
}

module "cloud-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 1.2"
  project_id    = module.enabled_google_apis.project_id
  region        = var.gcp_region
  router        = "safer-router"
  network       = module.vpc.network_self_link
  create_router = true
}
