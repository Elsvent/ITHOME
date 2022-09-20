# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

data "google_compute_subnetwork" "subnetwork" {
  name    = module.vpc.subnets_names.0
  project = var.gcp_project
  region  = var.gcp_region
  depends_on = [module.vpc]
}

provider "kubernetes" {
  host                   = "https://${module.gke-private.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke-private.ca_certificate)
}

# private cluster-bastion need implement
#
# check l7 lb enabled, need find dataplane v2
module "gke-private" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = var.gcp_project
  name                       = var.application_name
  region                     = var.gcp_region
  zones                      = [var.zone_a,var.zone_b,var.zone_c]
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names.0
  ip_range_pods              = module.vpc.subnets_secondary_ranges[0].0.range_name
  ip_range_services          = module.vpc.subnets_secondary_ranges[0].1.range_name
  master_ipv4_cidr_block     = "172.16.0.0/28"
  enable_private_endpoint    = false
  enable_private_nodes       = true
  remove_default_node_pool   = true
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  release_channel            = "STABLE"
  datapath_provider = "ADVANCED_DATAPATH"
  network_policy             = false

  master_authorized_networks = [
    {
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
    },
    {
    cidr_block   = "10.40.32.0/24"
    display_name = "VPC"
    },
    {
    cidr_block   = "10.40.48.0/20"
    display_name = "VPC"
    },
    {
    cidr_block   = "10.40.64.0/20"
    display_name = "VPC"
    },
    {
    cidr_block   = "59.124.15.133/32"
    display_name = "company address 1"
    },
    {
    cidr_block   = "106.104.121.159/32"
    display_name = "company address 2"
    },
    {
    cidr_block   = "175.182.179.51/32"
    display_name = "company address 3"
    },
    {
    cidr_block   = "175.181.178.205/32"
    display_name = "company address 4"
    },
    {
    cidr_block   = "175.182.177.86/32"
    display_name = "company address 5"
    },
    {
    cidr_block   = "175.181.156.184/32"
    display_name = "company address 6"
    },
    {
    cidr_block   = "59.115.207.11/32"
    display_name = "home ip"
    },
  ]

  node_pools = [
    {
      name                      = "static-node-pool"
      machine_type              = "e2-standard-4"
      node_locations            = "${var.zone_a},${var.zone_b},${var.zone_c}"
      autoscaling               = false
      node_count                = 1
      local_ssd_count           = 0
      disk_size_gb              = 50 
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "gke-sa@playground-355402.iam.gserviceaccount.com"
      preemptible               = false
    },
    {
      name                      = "compute-node-pool"
      machine_type              = "e2-highmem-2"
      node_locations            = "${var.zone_a},${var.zone_b},${var.zone_c}"
      min_count                 = 1
      max_count                 = 30
      local_ssd_count           = 0
      disk_size_gb              = 50
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      auto_repair               = true
      auto_upgrade              = true
      service_account           = "gke-sa@playground-355402.iam.gserviceaccount.com"
      preemptible               = true
      initial_node_count        = 1
    },
  ]

  node_pools_metadata = {
    all = {}
    static-node-pool = {}
    compute-node-pool = {}
  }

  node_pools_labels = {
    all = {
    }
    static-node-pool = {
      instance-type = "static"
    }
    compute-node-pool = {
      instance-type = "preemptible"
    }
  }

  node_pools_tags = {
    all = [
    ]
    static-node-pool = [
      "static-node-pool",
    ]
    compute-node-pool = [
      "preemptible-node-pool",
    ]
  }
}
