/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "random_password" "default" {
  length = 16
}

resource "google_alloydb_cluster" "dev_cluster" {  
  cluster_id   = "dev-cluster"
  location     = var.google_cloud_default_region
  database_version = "POSTGRES_15"

  initial_user {
    user     = "alloy_db_user"
    password =  random_password.default.result
  }

  ## Works if provided instead of psc_config block
  #network_config {
    #network = google_service_networking_connection.private_vpc_connection.network
  #}

  psc_config {
    psc_enabled = true
  }
}

resource "google_alloydb_instance" "dev_instance" {
  cluster       = google_alloydb_cluster.dev_cluster.name
  instance_id   = "alloydb-instance"
  instance_type = "PRIMARY"

  database_flags = {
    "alloydb.logical_decoding" = "on" # Enable logical decoding for Datastream
  }

  machine_config {
    cpu_count = 2
  }

  #Same error with or without this block
  psc_instance_config {
      allowed_consumer_projects = [local.project_num]
  }
}

resource "google_alloydb_user" "user1" {
  cluster = google_alloydb_cluster.dev_cluster.name
  user_id = "user1"
  user_type = "ALLOYDB_BUILT_IN"

  password = random_password.default.result
  database_roles = ["alloydbsuperuser"]
  depends_on = [google_alloydb_instance.dev_instance]
}
# resource "google_sql_database_instance" "default" {
#   project          = var.google_cloud_db_project
#   database_version = "POSTGRES_15"
#   name             = "toys-inventory"
#   region           = var.google_cloud_default_region
#   root_password    = random_password.default.result
#   settings {
#     edition           = "ENTERPRISE_PLUS"
#     tier              = "db-perf-optimized-N-8" # 8 vCPU, 64GB RAM
#     availability_type = "REGIONAL"
#     disk_size         = 250
#     backup_configuration {
#       enabled                        = true
#       point_in_time_recovery_enabled = true
#     }
#     database_flags {
#       name  = "cloudsql.iam_authentication"
#       value = "on"
#     }
#     ip_configuration {
#       ssl_mode = "ENCRYPTED_ONLY"
#       psc_config {
#         psc_enabled = true
#         allowed_consumer_projects = [
#           var.google_cloud_k8s_project
#         ]
#       }
#       ipv4_enabled = false
#     }
#     data_cache_config {
#       data_cache_enabled = true
#     }
#   }
#   # Note: in production environments, this setting should be true to prevent
#   # accidental deletion. Set it to false to make tf apply and destroy work
#   # quickly.
#   deletion_protection = false
# }

# resource "google_sql_user" "iam_sa_user" {
#   name     = local.iam_sa_username
#   instance = google_sql_database_instance.default.name
#   type     = "CLOUD_IAM_SERVICE_ACCOUNT"
#   project  = var.google_cloud_db_project
# }

# resource "google_sql_database" "default" {
#   name     = "retail"
#   instance = google_sql_database_instance.default.name
#   project  = var.google_cloud_db_project
# }
