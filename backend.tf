terraform {
  backend "s3" {
    bucket         = "my-pc-bucket3"
    key            = "default/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "petclinic-table"
    encrypt        = "true"
  }
}