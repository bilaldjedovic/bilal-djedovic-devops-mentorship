## **TASK 12 key parts:**

**Packer:**

    {

    "builders": [

    {

    "type": "amazon-ebs",

    "region": "eu-central-1",

    "profile": "bilcho",

    "source_ami": "ami-07ce6ac5ac8a0ee6f",

    "instance_type": "t2.micro",

    "ssh_username": "ec2-user",

    "temporary_key_pair_type": "ed25519",

    "ami_name": "devops-mentorship-task-12 {{timestamp}}",

    "tags": {

    "Name": "task12-web-server",

    "CreatedBy": "bilaldjedovic",

    "Project": "TASK-12",

    "IaC": "Packer"

    }

    }

    ],

    "provisioners": [

    {

    "type": "shell",

    "script": "./shell/nginxInstall.sh"

    },

    {

    "type": "shell",

    "script": "./shell/mysqlInstall.sh"

    }

    ]

    }

**Shell scripts needed for AMI:**
_mysqlInstall.sh_

    echo  "This is script to enable mysql repositories"
    sudo  rpm  --import  https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
    wget  http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm

_nginxInstall.sh_

    #/bin/bash

    echo  "This is script to enable nginx yum repositories"
    sleep  30
    echo  Updating  yum
    sudo  yum  update  -y
    sudo  yum  install  -y  yum-utils

**CloudFormation:**

    AWSTemplateFormatVersion: "2010-09-09"

    Resources:

    WebServerInstance:

    Type: "AWS::EC2::Instance"

    Properties:

    InstanceType: "t2.micro"

    ImageId: "ami-01227d7955a42d782"

    SecurityGroupIds:

    - !Ref  WebServerSecurityGroup

    SubnetId: "subnet-07f09b1c0fe19bb35"

    KeyName: bilal-djedovic-web-server-key

    Tags:

    - Key: Name

    Value: task-12-web-server-cf

    - Key: CreatedBy

    Value: bilaldjedovic

    - Key: Project

    Value: task-12

    - Key: IaC

    Value: CloudFormation



    DBServerInstance:

    Type: "AWS::EC2::Instance"

    Properties:

    InstanceType: "t2.micro"

    ImageId: "ami-01227d7955a42d782"

    SecurityGroupIds:

    - !Ref  DBServerSecurityGroup

    SubnetId: "subnet-0e0d76403c9ad0d1d"

    KeyName: bilal-djedovic-web-server-key

    Tags:

    - Key: Name

    Value: task-12-web-server-cf

    - Key: CreatedBy

    Value: bilaldjedovic

    - Key: Project

    Value: task-12

    - Key: IaC

    Value: CloudFormation



    WebServerSecurityGroup:

    Type: "AWS::EC2::SecurityGroup"

    Properties:

    GroupDescription: "Security group for the web server"

    VpcId: "vpc-009361844b58c10e8"

    SecurityGroupIngress:

    - CidrIp: 0.0.0.0/0

    FromPort: 22

    IpProtocol: tcp

    ToPort: 22

    - IpProtocol: tcp

    FromPort: 80

    ToPort: 80

    CidrIp: 0.0.0.0/0



    DBServerSecurityGroup:

    Type: "AWS::EC2::SecurityGroup"

    Properties:

    GroupDescription: "Security group for the database server"

    VpcId: "vpc-009361844b58c10e8"

    SecurityGroupIngress:

    - CidrIp: 0.0.0.0/0

    FromPort: 22

    IpProtocol: tcp

    ToPort: 22

    - IpProtocol: tcp

    FromPort: 3306

    ToPort: 3306

    CidrIp: 0.0.0.0/0

**Terraform:**

    resource "aws_instance" "web_server" {

    ami = "ami-01227d7955a42d782"

    instance_type = "t2.micro"

    subnet_id = "subnet-07f09b1c0fe19bb35"

    key_name = "bilal-djedovic-web-server-key"

    vpc_security_group_ids = [aws_security_group.web_server.id]



    tags = {

    Name = "task-12-webserver-tf"

    CreatedBy = "bilaldjedovic"

    Project = "task-12"

    IaC = "Terraform"

    }

    }



    resource "aws_instance" "db_server" {

    ami = "ami-01227d7955a42d782"

    instance_type = "t2.micro"

    subnet_id = "subnet-0e0d76403c9ad0d1d"

    key_name = "bilal-djedovic-web-server-key"

    vpc_security_group_ids = [aws_security_group.db_server.id]

    tags = {

    Name = "task-12-dbserver-tf"

    CreatedBy = "bilaldjedovic"

    Project = "task-12"

    IaC = "Terraform"

    }

    }



    resource "aws_security_group" "web_server" {

    name = "web-server-sg"

    description = "Security group for the web server"

    vpc_id = "vpc-009361844b58c10e8"



    ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    }

    }



    resource "aws_security_group" "db_server" {

    name = "db-server-sg"

    description = "Security group for the database server"

    vpc_id = "vpc-009361844b58c10e8"



    ingress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    }

    }

**Ansible:**

_Nginx install on web server:_

    ---

    - name: Install Nginx

    hosts: WebServers

    remote_user: ec2-user

    become: true



    tasks:

    - name: Install Nginx

    yum:

    name: nginx

    state: present



    - name: Start Nginx service

    service:

    name: nginx

    state: started



    - name: Enable Nginx service

    service:

    name: nginx

    enabled: yes

_SQL install:_

    - name: DB servers playbook

    hosts: DBServers

    become: yes

    tasks:

    - name: Copy sh script

    copy:

    src: mySqlInstall.sh

    dest: /home/ec2-user/mySqlInstall.sh

    owner: root

    group: root

    mode: 0777

    - name: Run sh script

    shell: /home/ec2-user/mySqlInstall.sh

    - name: Install mysql

    dnf:

    name: mysql-community-server

    state: latest
