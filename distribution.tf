resource "aws_imagebuilder_distribution_configuration" "distribution" {
  name = "distribution-configuration"

  distribution {
    region = data.aws_region.current.name
    ami_distribution_configuration {
      ami_tags = { "Name" = "my-pipeline-ami" }
    }
  }

  distribution {
    region = "eu-west-1"
    ami_distribution_configuration {
      ami_tags = { "Name" = "my-pipeline-ami" }
    }
  }
}