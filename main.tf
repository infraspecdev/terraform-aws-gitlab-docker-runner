resource "aws_key_pair" "ansible" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMI/oUO7c6QPEUhjQktSRnLDp6VX1IRBzQH9CB4l30C9BBKSS2rhLBkEYopJQkKbFeWbwxEMPL/QWdsOAQnsCTujGAbUMZ8Yepe6kk22nOsvIjsfO+yxptJOUxX3xFmWp2aDr/A/wxAopr80vsI9QpaP86DYSZUimlUxoXS2JjPHbpPC2UICj7FVLqmM4BjxTJUuFoy4664htdtuNNTO5X98DRWfHsZj9mzMeKcxgf7sV1t8el3lC0Yi2qoOs+K7iSlA81YFhc9r7rs+BRZSDrBykiu5ImFdasfjaG7q2eUG0ypO22FT8FPIz7c3CZTTX/I+W2BBWFQu3YlCjUKFuxGpL6ApNQMNsvzvKsSdJMsVFKREgMkRR9JmbTz52qEdc2zuSROOrH0Ov/NVko4Daj+B3seUeCqZTM4Uy7/aP+k/ZsHijOFs4X3u69gdN8CH8/BVUefknfNksc317E40F3WeWfMmyyBv0tKKc8OffFu0tdddG2BKXm/f4mQM7fD5s= ansible"
  key_name   = "ansible"

  tags = {
    Name      = "ansible"
    ManagedBy = "Terraform"
  }
}

resource "aws_instance" "terraform-gitlab-docker-runner" {
  ami                         = "ami-074cc9cf7a6bfbd02"
  instance_type               = "c6g.medium"
  key_name                    = aws_key_pair.ansible.id
  vpc_security_group_ids      = ["sg-0ecbf0cc9789639b8"]
  subnet_id                   = "subnet-0add22dd44185ea41"
  associate_public_ip_address = false

  provisioner "local-exec" {
    command = "ansible-playbook playbooks/gitlab_runner.yaml -i ${self.private_ip}, -u ubuntu --private-key '/Users/rajattomar/.ssh/ansible/id_rsa' --extra-vars 'ip=${self.private_ip}'"
  }

  tags = {
    Name      = "gitlab-docker-runner"
    ManagedBy = "Terraform"
  }
}
