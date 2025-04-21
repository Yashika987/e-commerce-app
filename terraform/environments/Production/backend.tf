terraform {
    backend "s3" {
      bucket = "easyshop-terraform-state"
      key = "prod/eks/terraform.tfstate"
      region = "us-east-1"
      //dynamodb_table = "easyshop-locks"
      encrypt        = true
    }
    
}