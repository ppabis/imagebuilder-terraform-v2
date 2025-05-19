#############################################
# When you are ready, create terraform.tfvars file and write:
# create_test_instance = true
# This will create a test instance from the AMI that you should have created.
#############################################

variable "create_test_instance" {
  type    = bool
  default = false
}

data "aws_ami" "my_ami" {
  count       = var.create_test_instance ? 1 : 0
  most_recent = true
  owners      = ["self"]
  tags        = { "Name" = "my-pipeline-ami" }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    cat > /etc/nginx/conf.d/default.conf << EOT
        server {
            listen 8080;
            server_name _;
            location / {
                proxy_pass http://localhost:8888;
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
            }
        }
    EOT
    if ! docker ps -a | grep -q caddy; then
      docker create --name caddy -p 8888:80 --restart=always caddy:latest
    fi
    docker start caddy
    systemctl restart nginx
    EOF
}

module "security_group_test" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name                = "test-instance-sg"
  vpc_id              = module.vpc.vpc_attributes.id
  description         = "Security group for Image Builder"
  egress_rules        = ["all-all"]
  ingress_rules       = ["http-8080-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "test_instance" {
  count                  = var.create_test_instance ? 1 : 0
  ami                    = data.aws_ami.my_ami[0].id
  instance_type          = "t4g.micro"
  vpc_security_group_ids = [module.security_group_test.security_group_id]
  subnet_id              = values(module.vpc.public_subnet_attributes_by_az)[1].id # Use a different subnet because why not
  tags                   = { "Name" = "test-instance" }
  user_data              = local.user_data
  iam_instance_profile = module.instance_profile.iam_instance_profile_name
}

output "test_instance_public_ip" {
  value = aws_instance.test_instance[0].public_ip
}