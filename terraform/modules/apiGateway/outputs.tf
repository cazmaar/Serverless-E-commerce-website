output "one" {
  value = aws_api_gateway_rest_api.apiGateway
}
output "two" {
  value = aws_api_gateway_resource.product
}
output "three" {
  value = aws_api_gateway_method.productMethod
}
output "four" {
  value = aws_api_gateway_integration.LambdaIntegration
}
# output "five" {
#   value = aws_lambda_permission.apigw_lambda
# }