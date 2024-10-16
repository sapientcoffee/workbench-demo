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


gcloud container clusters get-credentials prod-toy-store-semantic-search \
    --region=${GOOGLE_CLOUD_DEFAULT_REGION}


./scripts/configure-k8s.sh ${GOOGLE_CLOUD_PROJECT} ${GOOGLE_CLOUD_DEFAULT_REGION}

kubectl apply -f ../init-db/k8s/job.yaml
kubectl get jobs

kubectl apply -f ../load-embeddings/k8s/job.yaml
kubectl apply -f ../chatbot-api/k8s/deployment.yaml
kubectl apply -f ../chatbot-api/k8s/service.yaml

kubectl get services
kubectl get pods

