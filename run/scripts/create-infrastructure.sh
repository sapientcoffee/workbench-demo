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

# set -e # bail out early if any command fails
# set -u # fail if we hit unset variables
# set -o pipefail # fail if any component of any pipe fails

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

echo "Initiating the deployment"
gcloud infra-manager deployments apply projects/${PROJECT_ID}/locations/us-central1/deployments/workbench-deployment-run \
    --service-account projects/${PROJECT_ID}/serviceAccounts/infra-manager@${PROJECT_ID}.iam.gserviceaccount.com \
    --git-source-repo=https://github.com/sapientcoffee/workbench-demo \
    --git-source-directory=run/terraform \
    --git-source-ref=main \
    --input-values=google_cloud_project="${GOOGLE_CLOUD_PROJECT}",google_cloud_default_region="${GOOGLE_CLOUD_DEFAULT_REGION}",google_cloud_db_project="${GOOGLE_CLOUD_PROJECT}",google_cloud_k8s_project=${GOOGLE_CLOUD_PROJECT},create_bastion=${CREATE_BASTION}

# cd run/init-db
# gcloud builds submit --config cloudbuild.yaml --region <YOUR_CHOSEN_REGION>



