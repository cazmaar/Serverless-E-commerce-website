resource "aws_dynamodb_table" "product-dynamodb-table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
#   range_key      = "GameTitle"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "product-dynamodb-table"
    Environment = "production"
  }
}

