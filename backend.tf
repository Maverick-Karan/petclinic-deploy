terraform {
  backend "s3" {
    bucket         = "pc-remotestate"
    key            = "default/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pet-state-locking"
    encrypt        = "true"
  }
}