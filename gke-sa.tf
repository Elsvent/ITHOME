resource "google_service_account" "service_account" {
  project      = var.gcp_project
  account_id   = "gke-sa"
  display_name = "gke-service-account"
}

# ----------------------------------------------------------------------------------------------------------------------
# ADD ROLES TO SERVICE ACCOUNT
# Grant the service account the minimum necessary roles and permissions in order to run the GKE cluster
# plus any other roles added through the 'service_account_roles' variable
# ----------------------------------------------------------------------------------------------------------------------
locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/storage.objectViewer"
  ])
}

resource "google_project_iam_member" "service_account-roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.gcp_project
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
