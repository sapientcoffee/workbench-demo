# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
export SERVICE_ACCOUNT=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")-compute@developer.gserviceaccount.com

random_number=$RANDOM


echo "${SERVICE_ACCOUNT} on ${PROJECT_ID}"


echo "Creating the project ${GOOGLE_CLOUD_PROJECT}"
gcloud projects create ${GOOGLE_CLOUD_PROJECT} \
  --folder "973220728174"
 
  # --organization "1093091204297"\


echo "Linking the billing account"
gcloud services enable cloudbilling.googleapis.com
# echo "debuging entry: new project is ${GOOGLE_CLOUD_PROJECT} and billing is ${BILLING_ACCOUNT}"
gcloud billing projects link ${GOOGLE_CLOUD_PROJECT} \
    --billing-account "017C65-6AC5ED-18E460"

echo "Enabling services in ${GOOGLE_CLOUD_PROJECT}"
gcloud services enable \
  storage.googleapis.com \
  sqladmin.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  container.googleapis.com \
  dns.googleapis.com \
  compute.googleapis.com \
  alloydb.googleapis.com \
  cloudaicompanion.googleapis.com \
  dataform.googleapis.com \
  aiplatform.googleapis.com \
  config.googleapis.com \
  secretmanager.googleapis.com \
  --project=${GOOGLE_CLOUD_PROJECT}-${random_number}

# gcloud iam service-accounts create cloud-build-sa \
#   --display-name "Cloud Build Service Account" \
#   --project ${GOOGLE_CLOUD_PROJECT}

# gcloud projects add-iam-policy-binding coffeedev-002 \
#   --member "serviceAccount:cloud-build-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com" \
#   --role "roles/cloudbuild.serviceAgent"




# Add Service Account
# gcloud projects add-iam-policy-binding coffeedev-002 \
#   --member="serviceAccount:infra-manager@coffeebench.iam.gserviceaccount.com" \
#   --role="roles/viewer" \
#   --role="roles/compute.networkAdmin" \
#   --role="roles/resourcemanager.projectAgent" \
#   --role="roles/billing.projectManager" \
#   --role="roles/serviceusage.consumer" \
#   --role="roles/storage.admin" \
#   --role="roles/storage.objectCreator" \
#   --role="roles/compute.securityAdmin" \
#   --role="roles/iam.serviceAccountAdmin" \
#   --role="roles/alloydb.admin" \
#   --role="roles/dns.admin" \
#   --role="roles/artifactregistry.admin" 

# Region for Infra Manager is hard-coded to us-central1
# gcloud infra-manager deployments apply projects/${PROJECT_ID}/locations/us-central1/deployments/${APP_ID} \
#      --service-account=projects/${PROJECT_ID}/serviceAccounts/${SERVICE_ACCOUNT} \
#      --local-source=terraform \
#      --input-values=project_id=${PROJECT_ID},region=${REGION},cluster_id=${APP_ID}


