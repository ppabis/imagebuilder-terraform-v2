AWS EC2 Image Builder example with Terraform
==========

More information here:

- [https://pabis.eu/blog/2025-05-23-AWS-EC2-Image-Builder-Example-Terraform.html](https://pabis.eu/blog/2025-05-23-AWS-EC2-Image-Builder-Example-Terraform.html)

This repository shows an example how to build an Amazon Machine Image using
AWS managed service called EC2 Image Builder. It is similar to Packer but much
simpler to use and is usable directly from AWS Console after deploying this
infrastructure.

This repository will create the following things:

- A new VPC in which the instances will be built,
- IAM role for the instance and security groups,
- Two example components: Docker and Nginx,
- A recipe of above components on top of latest Amazon Linux 2023,
- Infrastructure and distribution configurations,
- Pipeline for building the images.

In file `image.tf` you can also build the image directly from Terraform when
applying but it will lock the state for a long time (for me it took 20 minutes).
It's better to just use the pipeline from the GUI or CLI.

Test instance
--------------

Once you have deployed the whole setup and built and image, you can create
`terraform.tfvars` file with the following content:

```text
create_test_instance = true
```

It will then create a test instance from the AMI, configure Nginx and start
Caddy on Docker with user data. Use the public IP and port 8080 to test it.