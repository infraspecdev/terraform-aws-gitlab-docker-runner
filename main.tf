locals {
  tags = {
    Name      = "gitlab-docker-runner"
    ManagedBy = "Terraform"
  }
  runner_user_data = templatefile("templates/runner.tftpl", {
    gitlab_url                = var.gitlab_url
    runner_registration_token = var.runner_registration_token
    docker_image              = var.docker_image
    runner_description        = var.runner_description
    runner_tags               = "\"${join(", ", var.runner_tags)}\""
    run_untagged_jobs         = var.run_untagged_jobs
    runner_locked             = var.runner_locked
  })
}

resource "aws_key_pair" "gitlab_docker_runner" {
  count      = var.ssh_public_key != null ? 1 : 0
  key_name   = "gitlab-docker-runner"
  public_key = var.ssh_public_key

  tags = local.tags
}

resource "aws_instance" "gitlab_docker_runner" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.ssh_public_key != null ? aws_key_pair.gitlab_docker_runner[0].key_name : null
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.subnet_id
  user_data                   = local.runner_user_data
  user_data_replace_on_change = var.user_data_replace_on_change

  tags = local.tags
}
