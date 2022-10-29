resource "random_string" "username" {
  length  = 16
  special = false
}

resource "random_password" "password" {
  length = 16
}

resource "random_password" "encryption_key" {
  length = 16
}

resource "random_password" "jwt_secret" {
  length = 16
}

resource "google_secret_manager_secret" "retool_database_username" {
  secret_id = "retool-database-username"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "retool_database_username_version" {
  secret = google_secret_manager_secret.retool_database_username.id

  secret_data = random_string.username.result
}

resource "google_secret_manager_secret" "retool_database_password" {
  secret_id = "retool-database-password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "retool_database_password_version" {
  secret = google_secret_manager_secret.retool_database_password.id

  secret_data = random_password.password.result
}

resource "google_secret_manager_secret" "retool_encryption_key" {
  secret_id = "retool-encryption-key"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "retool_encryption_key_version" {
  secret = google_secret_manager_secret.retool_encryption_key.id

  secret_data = random_password.encryption_key.result
}

resource "google_secret_manager_secret" "retool_jwt_secret" {
  secret_id = "retool-jwt-secret"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "retool_jwt_secret_version" {
  secret = google_secret_manager_secret.retool_jwt_secret.id

  secret_data = random_password.jwt_secret.result
}