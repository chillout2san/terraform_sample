# Cloud Run サービス
resource "google_cloud_run_v2_service" "sample_app" {
  name     = "sample-app-${var.environment}"
  location = "asia-northeast1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    containers {
      image = "gcr.io/google-samples/hello-app:1.0"
      ports {
        container_port = 8080
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }

  depends_on = [google_project_service.cloud_run]
}

# Cloud Run サービスへのパブリックアクセスを許可
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "noauth" {
  location = google_cloud_run_v2_service.sample_app.location
  project  = google_cloud_run_v2_service.sample_app.project
  name     = google_cloud_run_v2_service.sample_app.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
