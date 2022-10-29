resource "google_project_service" "apis_and_services" {
  for_each = toset(var.apis_and_services)

  project = var.project_id
  service = each.value
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"

  depends_on = [google_project_service.apis_and_services]
}

resource "google_artifact_registry_repository" "retool" {
  location      = var.region
  repository_id = "retool"
  description   = "Retool Docker repository"
  format        = "DOCKER"

  depends_on = [time_sleep.wait_60_seconds]
}