data "aws_region" "current" {}

data "aws_imagebuilder_image" "latest" {
  arn = "arn:aws:imagebuilder:${data.aws_region.current.name}:aws:image/amazon-linux-2023-arm64/x.x.x"
}

resource "aws_imagebuilder_image_recipe" "image_recipe" {
  component { 
    component_arn = aws_imagebuilder_component.docker_component.arn
  }
  component { 
    component_arn = aws_imagebuilder_component.nginx_component.arn
    parameter {
      name  = "port"
      value = "9001"
    }
  }
  name         = "my-image-recipe"
  parent_image = data.aws_imagebuilder_image.latest.build_version_arn
  version      = "1.0.0"
  description  = "This is a recipe that takes latest Amazon Linux 2023 and installs latest Docker, Nginx and configures it."
}