resource "aws_api_gateway_rest_api" "apiGateway" {
  name        = "ecommerce"
  description = "This is my API for demonstration purposes"
}

resource "aws_api_gateway_resource" "product" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  parent_id   = aws_api_gateway_rest_api.apiGateway.root_resource_id
  path_part   = "product"
}

resource "aws_api_gateway_method" "productMethod" {
  rest_api_id   = aws_api_gateway_rest_api.apiGateway.id
  resource_id   = aws_api_gateway_resource.product.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "LambdaIntegration" {
  rest_api_id          = aws_api_gateway_rest_api.apiGateway.id
  resource_id          = aws_api_gateway_resource.product.id
  http_method          = aws_api_gateway_method.productMethod.http_method
  integration_http_method = "GET"
  uri = var.invokeArn
  type                 = "AWS"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.apiGateway.id}/*/${aws_api_gateway_method.productMethod.http_method}${aws_api_gateway_resource.product.path}"
}


# resource "aws_api_gateway_method_response" "response_200" {
#   rest_api_id = aws_api_gateway_rest_api.apiGateway.id
#   resource_id = aws_api_gateway_resource.product.id
#   http_method = aws_api_gateway_method.productMethod.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
#   rest_api_id = aws_api_gateway_rest_api.apiGateway.id
#   resource_id = aws_api_gateway_resource.product.id
#   http_method = aws_api_gateway_method.productMethod.http_method
#   status_code = aws_api_gateway_method_response.response_200.status_code
# }