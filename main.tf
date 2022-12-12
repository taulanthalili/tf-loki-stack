resource "argocd_application" "loki" {
  metadata {
    name      = "loki-${var.environment}"
    namespace = var.namespace
    labels = {
      environment = var.environment
      namespace   = var.namespace
    }
  }
  wait = true
  timeouts {
    create = "20m"
    delete = "10m"
  }
  spec {
    project = var.argocd_project
    source {
      repo_url        = "https://grafana.github.io/helm-charts"
      chart           = "loki-stack"
      target_revision = var.helm_version.loki-stack
      helm {
        value_files  = ["values.yaml"]

      }

    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.namespace
    }
    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      sync_options = ["Validate=false", "RespectIgnoreDifferences=true"]
      retry {
        limit = "5"
        backoff = {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [metadata]
  }
}
