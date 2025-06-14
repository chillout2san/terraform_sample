# Container Registry を有効にする
resource "google_project_service" "container_registry" {
  service = "containerregistry.googleapis.com"
}

# Cloud Run を有効にする
resource "google_project_service" "cloud_run" {
  service = "run.googleapis.com"
}
