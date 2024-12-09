provider "aws" {
  #profile = "default"
  region = var.region
}

provider "vault" {
  address = var.vault_url
  #skip_child_token = true
  auth_login {
    path      = "auth/aws/login"
    namespace = var.vault_namespace
    method    = "aws"
    parameters = {
      sts_region              = "us-east-1"
      iam_http_request_method = "POST"
      role                    = var.vault_role
    }
  }
}
