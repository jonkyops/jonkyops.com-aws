# JonkyOps-aws

Infrastructure for jonkyops.com

## Installation

## Usage

Make an SSM parameter for your github oath token, name it GitHubOath and make sure the version is correct in the pipeline-terraform.yml.
Run the cloudformation template in AWS to create the terraform pipeline.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate (if there are any).

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Acknowledgments

- [Soenke Ruempler](https://ruempler.eu/2017/02/26/continuous-infrastructure-delivery-pipeline-aws-codepipeline-codebuild-terraform/) - terraform pipeline cfn template
- [makeareadme.com](https://www.makeareadme.com/) - readme template
- [gitignore.io](https://www.gitignore.io) - gitignore file
- [Danny Perez](https://codeburst.io/creating-your-serverless-static-website-in-terraform-part-2-6e6a26bc7a79) - serverless bucket setup, really like the emphasis on security in this article
