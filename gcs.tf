resource "google_storage_bucket" "terraform_backend" {
  name           = "terraform-playground-backend"
  location       = var.location
  storage_class  = "MULTI_REGIONAL"
  versioning {
    enabled = "true"
  }

  labels         = {
      infra = "terraform_backend"
  }
}
