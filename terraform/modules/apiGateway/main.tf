resource "aws_api_gateway_rest_api" "apiGateway" {
  name        = "ecommerce"
  description = "This is my API for demonstration purposes"
   endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id

  # triggers = {
  #   redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example.body))
  # }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method.productMethod,
    aws_api_gateway_integration.LambdaIntegration
  ]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.apiGateway.id
  stage_name    = "example"
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
  source_arn = "${aws_api_gateway_rest_api.apiGateway.execution_arn}/*/*"
}


resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.productMethod.http_method
  status_code = "200"
  response_models ={
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.productMethod.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  depends_on = [
    aws_api_gateway_integration.LambdaIntegration
  ]
}