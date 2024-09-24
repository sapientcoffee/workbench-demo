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
data "google_project" "project" {
}

locals {
  network_name        = "appdev-network"
  subnet_name         = "k8s-subnet"
  gke_pods_range_name = "gke-pods-autopilot-private"
  gke_svc_range_name  = "gke-svc-autopilot-private"
  project_num = data.google_project.project.number

  subnet_names = [
    for subnet_self_link in module.gcp_network.subnets_self_links :
    split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]
  ]

  iam_sa_username = trimsuffix(
    module.workload_identity.gcp_service_account_email,
    ".gserviceaccount.com",
  )
}
