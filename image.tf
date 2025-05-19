# Uncomment this to directly create an image using Terraform.
# 🚨 DANGER! It will lock the state for a very long time.
# resource "aws_imagebuilder_image" "image" {
#   distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.distribution.arn
#   image_recipe_arn                 = aws_imagebuilder_image_recipe.image_recipe.arn
#   infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.infrastructure.arn
# }