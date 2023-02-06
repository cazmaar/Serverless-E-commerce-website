provider "aws" {
  region = "eu-west-2"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "e-commerce-ade"
    key    = "e-commerce/state.tfstate"
    region = "eu-west-2"
  }
}

module "product_database" {
  source     = "./modules/productDatabase"
  table_name = "productTable"
}

module "product_lambda_function" {
  source               = "./modules/productLambda"
  lambda_function_name = "productFunction"
}

module "apiGw" {
  source   = "../terraform/modules/apiGateway"
  myregion = var.region
  accountId = var.accountId
  function_name = module.product_lambda_function.productLambda.function_name
  invokeArn = module.product_lambda_function.productLambda.invoke_arn
}
