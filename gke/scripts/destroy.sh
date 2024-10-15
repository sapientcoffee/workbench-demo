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

gcloud projects delete ${GOOGLE_CLOUD_PROJECT}

# Region for Infra Manager is hard-coded to us-central1
# gcloud infra-manager deployments delete projects/${PROJECT_ID}/locations/us-central1/deployments/${APP_ID}
gcloud infra-manager deployments delete projects/${PROJECT_ID}/locations/us-central1/deployments/workbench-deployment


#   gcloud builds triggers delete TRIGGER_NAME