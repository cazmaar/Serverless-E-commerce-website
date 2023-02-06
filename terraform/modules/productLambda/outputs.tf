output "productLambda" {
  value = aws_lambda_function.product_function
}
output "productLambda1" {
  value = aws_lambda_function.product_function.invoke_arn
}