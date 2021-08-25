terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.type
}
