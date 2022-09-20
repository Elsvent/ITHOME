resource "google_compute_instance" "default" {
  name         = "testvm"
  machine_type = "e2-micro"
  zone         = var.zone
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    network = "default"
  }
}
