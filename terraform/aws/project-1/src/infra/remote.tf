
data "terraform_remote_state" "global" {
  backend = "s3"
  config {
    bucket  = "${var.account}-state"
    key     = "global/terraform.state"
    encrypt = 1
  }
}
