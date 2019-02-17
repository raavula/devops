terraform {
  backend "s3" {
    bucket  = "raghav-eks-example-state"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    encrypt = true    
  }
}
