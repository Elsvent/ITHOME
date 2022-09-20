resource "google_service_account" "terraform" {
  account_id   = "terraform"
  description  = "terraform service account"
  display_name = "terraform"
  project      = "playground-355402"
}
# terraform import google_service_account.terraform projects/playground-355402/serviceAccounts/terraform@playground-355402.iam.gserviceaccount.com
module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 6.4"
  projects = [ "playground-355402" ]
  bindings = {
    "roles/owner" = [
      "serviceAccount:terraform@playground-355402.iam.gserviceaccount.com"
    ]
    "roles/compute.admin" = [
      "serviceAccount:terraform@playground-355402.iam.gserviceaccount.com"
    ]
    "roles/compute.storageAdmin" = [
      "serviceAccount:terraform@playground-355402.iam.gserviceaccount.com"
    ]
    "roles/container.admin" = [
      "serviceAccount:terraform@playground-355402.iam.gserviceaccount.com"
    ]
    "roles/iam.serviceAccountAdmin" = [
      "serviceAccount:terraform@playground-355402.iam.gserviceaccount.com"
    ]
    "roles/resourcemanager.projectIamAdmin" = [
      "serviceAccount:terraform@playground-355402.iam.gserviceaccount.com"
    ]
    "roles/storage.admin" = [
      "serviceAccount:terraform@playground-355402.iam.gserviceaccount.com"
    ]

  }
}
