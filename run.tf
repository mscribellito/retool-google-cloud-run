module "retool_api" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "0.3.0"

  service_name = "retool-api"
  project_id   = var.project_id
  location     = var.region
  env_vars = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "SERVICE_TYPE"
      value = "MAIN_BACKEND,DB_CONNECTOR"
    },
    {
      name  = "POSTGRES_DB"
      value = "hammerhead_production"
    },
    {
      name  = "POSTGRES_HOST"
      value = "/cloudsql/${module.retool_database.instance_connection_name}"
    },
    {
      name  = "POSTGRES_SSL_ENABLED"
      value = "false"
    },
    {
      name  = "POSTGRES_PORT"
      value = "5432"
    },
    {
      name  = "LICENSE_KEY"
      value = "SSOP_26043bdf-e085-47f2-bc5c-04bf493e02b3"
    }
  ]
  env_secret_vars = [
    {
      name = "POSTGRES_USER"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_database_username.secret_id
          key  = "latest"
        }
      }]
    },
    {
      name = "POSTGRES_PASSWORD"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_database_password.secret_id
          key  = "latest"
        }
      }]
    },
    {
      name = "JWT_SECRET"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_jwt_secret.secret_id
          key  = "latest"
        }
      }]
    },
    {
      name = "ENCRYPTION_KEY"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_encryption_key.secret_id
          key  = "latest"
        }
      }]
    }
  ]
  image = "us-east1-docker.pkg.dev/retool-366417/retool/retool@sha256:6351bc40d5753a13e564e548d61b49763482d1f3c1ea3a27c409ebc2a1e8100c"
  container_command = [
    "./docker_scripts/start_api.sh",
  ]

  limits = {
    cpu    = "1000m"
    memory = "2048Mi"
  }
  members = ["allUsers"]
  ports = {
    "name" : "http1",
    "port" : 3000
  }
  service_account_email = module.retool_service_account.email
  template_annotations = {
    "autoscaling.knative.dev/minScale"      = 1
    "generated-by"                          = "terraform"
    "run.googleapis.com/client-name"        = "terraform"
    "run.googleapis.com/cloudsql-instances" = module.retool_database.instance_connection_name
  }

  depends_on = [time_sleep.wait_60_seconds]
}

module "retool_jobs_runner" {
  source  = "GoogleCloudPlatform/cloud-run/google"
  version = "0.3.0"

  service_name = "retool-jobs-runner"
  project_id   = var.project_id
  location     = var.region
  env_vars = [
    {
      name  = "NODE_ENV"
      value = "production"
    },
    {
      name  = "SERVICE_TYPE"
      value = "JOBS_RUNNER"
    },
    {
      name  = "POSTGRES_DB"
      value = "hammerhead_production"
    },
    {
      name  = "POSTGRES_HOST"
      value = "/cloudsql/${module.retool_database.instance_connection_name}"
    },
    {
      name  = "POSTGRES_SSL_ENABLED"
      value = "false"
    },
    {
      name  = "POSTGRES_PORT"
      value = "5432"
    },
    {
      name  = "LICENSE_KEY"
      value = "SSOP_26043bdf-e085-47f2-bc5c-04bf493e02b3"
    }
  ]
  env_secret_vars = [
    {
      name = "POSTGRES_USER"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_database_username.secret_id
          key  = "latest"
        }
      }]
    },
    {
      name = "POSTGRES_PASSWORD"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_database_password.secret_id
          key  = "latest"
        }
      }]
    },
    {
      name = "JWT_SECRET"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_jwt_secret.secret_id
          key  = "latest"
        }
      }]
    },
    {
      name = "ENCRYPTION_KEY"
      value_from = [{
        secret_key_ref = {
          name = google_secret_manager_secret.retool_encryption_key.secret_id
          key  = "latest"
        }
      }]
    }
  ]
  image = "us-east1-docker.pkg.dev/retool-366417/retool/retool@sha256:6351bc40d5753a13e564e548d61b49763482d1f3c1ea3a27c409ebc2a1e8100c"
  container_command = [
    "./docker_scripts/start_api.sh",
  ]

  limits = {
    cpu    = "1000m"
    memory = "2048Mi"
  }
  ports = {
    "name" : "http1",
    "port" : 3000
  }
  service_account_email = module.retool_service_account.email
  template_annotations = {
    "autoscaling.knative.dev/minScale"      = 1
    "generated-by"                          = "terraform"
    "run.googleapis.com/client-name"        = "terraform"
    "run.googleapis.com/cloudsql-instances" = module.retool_database.instance_connection_name
  }

  depends_on = [time_sleep.wait_60_seconds]
}