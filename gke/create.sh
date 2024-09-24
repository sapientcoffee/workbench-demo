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

echo $SERVICE_ACCOUNT

# Region for Infra Manager is hard-coded to us-central1
# gcloud infra-manager deployments apply projects/${PROJECT_ID}/locations/us-central1/deployments/${APP_ID} \
#      --service-account=projects/${PROJECT_ID}/serviceAccounts/${SERVICE_ACCOUNT} \
#      --local-source=terraform \
#      --input-values=project_id=${PROJECT_ID},region=${REGION},cluster_id=${APP_ID}

gcloud infra-manager deployments apply projects/coffeebench/locations/us-central1/deployments/workbench-deployment \
    --service-account projects/coffeebench/serviceAccounts/infra-manager@coffeebench.iam.gserviceaccount.com \
    --git-source-repo=https://github.com/sapientcoffee/workbench-demo \
    --git-source-directory=gke/terraform \
    --git-source-ref=main \
    --input-values=google_cloud_project="quickbuild-workbench",google_cloud_default_region="us-central1",google_cloud_db_project="quickbuild-workbench",google_cloud_k8s_project=quickbuild-workbench,create_bastion=false