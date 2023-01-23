module "gitlab_docker_runner" {
  source = "../"

  ami_id                    = "ami-0675b5ed3c8c1f754"
  instance_type             = "t2.micro"
  instance_count            = 1
  vpc_security_group_ids    = ["sg-0b0b0b0b0b0b0b0b0"]
  subnet_id                 = "subnet-0b0e1c4b5b1b1b1b1"
  gitlab_url                = "https://gitlab.example.com"
  runner_registration_token = "runner-registration-token-here"
  ssh_public_key            = "ssh-public-key-here"
}
