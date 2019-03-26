# zip up the function to send to lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/function.zip"
}

resource "aws_lambda_function" "edge_lambda" {
  function_name = "oai-url-rewrite"
  filename      = "function.zip"
  handler       = "index.handler"
  runtime       = "nodejs8.10"
  publish       = "true"
  role          = "${aws_iam_role.lambda_edge.arn}"

  depends_on = ["data.archive_file.lambda_zip"]
}

# lambda @edge role/policy
data "aws_iam_policy_document" "lambda_edge_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "lambda_edge" {
  name               = "lambda-edge-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_edge_assume_role_policy.json}"
}
