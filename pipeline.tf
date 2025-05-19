resource "aws_imagebuilder_image_pipeline" "my_pipeline" {
  schedule {
    schedule_expression = "cron(0 0 ? * 7 *)" # Every Saturday at midnight
  }
  name                             = "my-pipeline"
  image_recipe_arn                 = aws_imagebuilder_image_recipe.image_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.infrastructure.arn
  distribution_configuration_arn   = aws_imagebuilder_distribution_configuration.distribution.arn
}