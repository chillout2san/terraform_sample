# ロードバランサーは以下の流れで構築される
# Internet → 転送ルール → HTTPプロキシ → URLマップ → Backend Service → NEG → Cloud Run

# 1. ロードバランサーのグローバル静的 IP アドレスを予約
resource "google_compute_global_address" "load_balancer_ip" {
  name = "sample-app-dev-lb-ip"
}

# 2. グローバル転送ルール
# これで対象の IP アドレスへのトラフィックは HTTP プロキシに送られるようになる
# IP アドレスとバックエンドの名前解決を行うようなもの
resource "google_compute_global_forwarding_rule" "load_balancer" {
  name       = "sample-app-dev-forwarding-rule"
  target     = google_compute_target_http_proxy.load_balancer.id
  ip_address = google_compute_global_address.load_balancer_ip.address
  port_range = "80"
}

# 3. HTTP プロキシと URL マップ
# URLマップを使ってトラフィックを処理する
resource "google_compute_target_http_proxy" "load_balancer" {
  name    = "sample-app-dev-http-proxy"
  url_map = google_compute_url_map.load_balancer.id
}

resource "google_compute_url_map" "load_balancer" {
  name        = "sample-app-dev-lb"
  description = "Load balancer for sample app"
  # ここにパスマッチングを書く
  default_service = google_compute_backend_service.cloud_run_backend.id
}

# 4. Cloud Run 用のバックエンドサービス
# Load Balancer からこの Backend へトラフィックが流れる
# どのようにトラフィックを送るかを制御する
resource "google_compute_backend_service" "cloud_run_backend" {
  name        = "sample-app-dev-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  # NEG にトラフィックが流れるように指定されている
  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }

  log_config {
    enable = true
  }
}

# 5. Cloud Run 用の Network Endpoint Group
# どこにサービスがあるかを知らせる役割
# Cloud Run のインスタンスは入れ替わるものなので、 NEG を使って場所を知らせる役割
resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = "sample-app-dev-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-northeast1"

  cloud_run {
    service = google_cloud_run_v2_service.sample_app.name
  }
}
