# Cloud Run サービス
resource "google_cloud_run_v2_service" "sample_app" {
  name     = "sample-app-dev"
  location = "asia-northeast1"
  ingress  = "INGRESS_TRAFFIC_ALL"

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

  depends_on = [module.terraform_sample_development]
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

# 出力
output "cloud_run_url" {
  description = "Cloud Run サービスの URL"
  value       = google_cloud_run_v2_service.sample_app.uri
}

# module 
module "terraform_sample_development" {
  source = "../module"
}
