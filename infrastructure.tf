module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.2.0"

  name       = "image-builder-vpc"
  cidr_block = "10.123.0.0/16"
  az_count   = 2
  subnets = {
    public  = { netmask = 24 }
    private = { netmask = 24 }
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name         = "instance-sg"
  vpc_id       = module.vpc.vpc_attributes.id
  description  = "Security group for Image Builder"
  egress_rules = ["all-all"]
}

module "instance_profile" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.55.0"

  trusted_role_services   = ["ec2.amazonaws.com"]
  role_name               = "image-builder-role"
  create_role             = true
  create_instance_profile = true
  role_requires_mfa       = false
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_imagebuilder_infrastructure_configuration" "infrastructure" {
  instance_types                = ["t4g.small", "t4g.medium"]
  security_group_ids            = [module.security_group.security_group_id]
  instance_profile_name         = module.instance_profile.iam_instance_profile_name
  subnet_id                     = values(module.vpc.public_subnet_attributes_by_az)[0].id
  name                          = "my-pipeline-infra"
  terminate_instance_on_failure = true
}