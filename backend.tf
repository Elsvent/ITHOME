terraform {
  backend "gcs" {
    bucket = "terraform-playground-backend"
    prefix = "terraform/state"

  }
}
