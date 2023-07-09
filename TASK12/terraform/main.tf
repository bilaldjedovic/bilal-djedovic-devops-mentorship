resource "aws_instance" "web_server" {
  ami           = "ami-01227d7955a42d782" 
  instance_type = "t2.micro"
  subnet_id     = "subnet-07f09b1c0fe19bb35" 
  key_name      = "bilal-djedovic-web-server-key"
  vpc_security_group_ids = [aws_security_group.web_server.id]

  tags = {
    Name = "task-12-webserver-tf"
    CreatedBy = "bilaldjedovic"
    Project = "task-12"
    IaC = "Terraform"
  }
}

resource "aws_instance" "db_server" {
  ami           = "ami-01227d7955a42d782"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0e0d76403c9ad0d1d" 
  key_name      = "bilal-djedovic-web-server-key"
  vpc_security_group_ids = [aws_security_group.db_server.id]
  tags = {
    Name = "task-12-dbserver-tf"
    CreatedBy = "bilaldjedovic"
    Project = "task-12"
    IaC = "Terraform"
  }
}

resource "aws_security_group" "web_server" {
  name        = "web-server-sg"
  description = "Security group for the web server"
  vpc_id      = "vpc-009361844b58c10e8" 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_security_group" "db_server" {
  name        = "db-server-sg"
  description = "Security group for the database server"
  vpc_id      = "vpc-009361844b58c10e8" 

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}