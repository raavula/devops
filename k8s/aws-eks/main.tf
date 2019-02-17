terraform {
  backend "s3" {
    bucket  = "example-eks-state"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    encrypt = true    
  }
}
