resource "aws_ssm_parameter" "github_oauth_token" {
  name      = "gitHubOath"
  type      = "SecureString"
  value     = "${var.github_oauth_token}"
  overwrite = true
}
