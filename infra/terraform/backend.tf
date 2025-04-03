#S3, GCS, or Azure Blob Storage for prod
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  /*
  backend "http" {
    address        = "https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/contents/terraform.tfstate"
    lock_address   = "https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/contents/terraform.tfstate.lock"
    unlock_address = "https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/contents/terraform.tfstate.lock"
    username       = "YOUR_USERNAME"
    # Set password via TF_VAR_github_token environment variable
  }
  */
}
