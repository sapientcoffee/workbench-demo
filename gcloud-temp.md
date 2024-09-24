gcloud infra-manager previews create projects/coffeebench/locations/us-central1/previews/quickbuild-workbench \
    --folder=rob-folder \
    --service-account projects/coffeebench/serviceAccounts/infra-manager@coffeebench.iam.gserviceaccount.com \
    --git-source-repo=https://github.com/sapientcoffee/workbench-demo \
    --git-source-directory=gke/terraform \
    --git-source-ref=main \
    --input-values=google_cloud_project="quickbuild-workbench",google_cloud_default_region="us-central1",google_cloud_db_project="quickbuild-workbench",google_cloud_k8s_project=quickbuild-workbench,create_bastion=false