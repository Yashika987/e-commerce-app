terraform {
    backend "s3" {
      bucket = "easyshop-terraform-state-prod"
      key = "prod/eks/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "easyshop-locks"
      encrypt        = true
    }
    
}