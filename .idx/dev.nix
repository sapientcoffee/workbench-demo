{ pkgs, ... }: 
{
    # Which nixpkgs channel to use.
    channel = "stable-24.05"; # or "unstable"
    # Use https://search.nixos.org/packages to find packages
    packages = [
      pkgs.python3
      pkgs.python311Packages.pip
      pkgs.python311Packages.fastapi
      pkgs.python311Packages.uvicorn
    ];
    # Sets environment variables in the workspace
    env = {
      GOOGLE_PROJECT = "<project-id>";
      CLOUDSDK_CORE_PROJECT = "<project-id>";
      TF_VAR_project = "<project-id>";
      # Quieter Terraform logs
      TF_IN_AUTOMATION = "true";
    };
    idx = {
      previews = {
        enable = true;
        previews = {
          web = {
            command = [ "./devserver.sh" ];
            env = { PORT = "$PORT"; };
            manager = "web";
          };
        };
      };
      # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
      extensions = [ 
        "googlecloudtools.cloudcode"
        "hashicorp.terraform" 
        ];
      workspace = {
        # Runs when a workspace is first created with this `dev.nix` file
        onCreate = {
          default.openFiles = [
          "README.md"
          "src/services/task.service.ts"
          ];
          terraform = ''
          terraform init --upgrade
          terraform apply -parallelism=20 --auto-approve -compact-warnings
          '';
          install =
            "python -m venv .venv && source .venv/bin/activate &&  pip install -r requirements.txt";
          # Open editors for the following files by default, if they exist:
          default.openFiles = [ "app.py" ];
        };
        # Runs when the workspace is (re)started
        onStart = {
         terraform = ''
          terraform apply -parallelism=20 --auto-approve -compact-warnings
        '';
      };
    };
  }