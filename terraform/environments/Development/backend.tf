terraform {
    backend "s3" {
      bucket = "easyshop-terraform-state"
      key    = "dev/eks/terraform.tfstate"
      region = "us-east-1"
      //dynamodb_table = "easyshop-locks"
      encrypt = true
    }
    
}
