resource "aws_imagebuilder_component" "docker_component" {
  name                  = "docker-component"
  platform              = "Linux"
  version               = "1.0.0"
  supported_os_versions = ["Amazon Linux 2023"]
  data                  = file("./components/docker.yaml")
}

resource "aws_imagebuilder_component" "nginx_component" {
  name                  = "nginx-component"
  platform              = "Linux"
  version               = "1.0.0"
  supported_os_versions = ["Amazon Linux 2023"]
  data                  = file("./components/nginx.yaml")
}