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

module "gcp_network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 7.5"

  project_id   = var.google_cloud_k8s_project
  network_name = local.network_name

  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = "10.0.0.0/24"
      subnet_region = var.google_cloud_default_region

      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = local.gke_pods_range_name
        ip_cidr_range = "192.168.0.0/24"
      },
      {
        range_name    = local.gke_svc_range_name
        ip_cidr_range = "192.168.64.0/24"
      },
    ]
  }

  ingress_rules = [
    {
      name          = "${local.network_name}-allow-ssh-ingress-from-iap",
      description   = "Allow traffic from IAP",
      priority      = 1000,
      source_ranges = ["35.235.240.0/20"],
      allow = [
        {
          protocol = "tcp",
          ports    = ["22"],
        },
      ],
    },
    {
      name          = "${local.network_name}-allow-internal"
      description   = "Allow internal traffic on the network",
      source_ranges = ["10.0.0.0/24"],
      allow = [
        {
          protocol = "tcp",
          ports    = ["0-65535"],
        },
        {
          protocol = "udp",
          ports    = ["0-65535"],
        },
        {
          protocol = "icmp",
        },
      ],
    },
  ]
}

resource "random_id" "address_id" {
  byte_length = 8
}

resource "google_compute_address" "default" {
  project      = var.google_cloud_k8s_project
  name         = "address-${random_id.address_id.hex}"
  region       = var.google_cloud_default_region
  subnetwork   = module.gcp_network.subnets_names[0]
  address_type = "INTERNAL"
}

resource "random_id" "forwarding_rule_id" {
  byte_length = 8
}

resource "google_compute_forwarding_rule" "default" {
  project                = var.google_cloud_k8s_project
  name                  = "forwarding-rule-${random_id.forwarding_rule_id.hex}"
  region                 = var.google_cloud_default_region
  network                = module.gcp_network.network_name
  ip_address             = google_compute_address.default.self_link
  target                 = google_alloydb_instance.dev_instance.psc_instance_config[0].service_attachment_link
  load_balancing_scheme  = ""
}

resource "google_dns_managed_zone" "psc" {
  project     = var.google_cloud_k8s_project
  name        = "dev-db-zone"
  dns_name    = "alloydb-psc.goog."
  description = "Regional zone for AlloyDB PSC instances"
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = module.gcp_network.network_id
    }
  }
}

resource "google_dns_record_set" "psc" {
  project      = var.google_cloud_k8s_project
  name         = google_alloydb_instance.dev_instance.psc_instance_config[0].psc_dns_name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.psc.name
  rrdatas      = [google_compute_address.default.address]
}
