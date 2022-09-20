# GCP authentication file
variable "gcp_auth_file" {
  type        = string
  description = "GCP authentication file"
}
# define GCP region
variable "gcp_region" {
  type        = string
  description = "GCP region"
}
# define GCP project name
variable "gcp_project" {
  type        = string
  description = "GCP project name"
}

variable "zone" {
  type = string
}

variable "location" {
  type         = string
  description  = "GCP location"
}
variable "company_name" {
  type        = string
}

variable "business_name" {
  type        = string
}

variable "application_name" {
  type        = string
}

variable "region_code" {
  type        = string
}

variable "env_code" {
  type        = string
}
variable "zone_a" {
  type    = string
  default = "us-west1-a"
}

variable "zone_b" {
  type    = string
  default = "us-west1-b"
}

variable "zone_c" {
  type    = string
  default = "us-west1-c"
}
variable "bastion_members" {
  type        = list(string)
  description = "List of users, groups, SAs who need access to the bastion host"
  default     = []
}
variable "service_account_roles" {
  description = "Additional roles to be added to the service account."
  type        = list(string)
  default     = []
}
