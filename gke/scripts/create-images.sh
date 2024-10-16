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

# List of directories
directories=("../init-db" "../chatbot-api" "../load-embeddings")

# Command to execute in each directory
command="gcloud builds submit --config cloudbuild.yaml --region us-east1 --project ${GOOGLE_CLOUD_PROJECT}"

# Loop through each directory
for dir in "${directories[@]}"; do
  # Change to the directory
  cd "$dir" || { echo "Failed to change to directory: $dir"; continue; }

  # Execute the command
  echo "Executing '$command' in directory: $dir"
  $command

  # Change back to the original directory
  cd -
done

echo "Finished processing all directories."


# gcloud builds submit --config cloudbuild.yaml --region us-east1