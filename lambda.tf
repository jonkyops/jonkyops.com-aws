# zip up the function to send to lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "index.js"
  output_path = "function.zip"
}

resource "aws_lambda_function" "edge_lambda" {
  function_name = "oai-url-rewrite"
  filename      = "function.zip"
  handler       = "index.handler"
  runtime       = "nodejs8.10"
  publish       = "true"
  role          = "${aws_iam_role.lambda_edge_role.arn}"

  depends_on = ["data.archive_file.lambda_zip"]
}
