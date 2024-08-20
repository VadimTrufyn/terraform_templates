data "aws_ami" "ubuntu" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}
data "aws_ami" "amazon" {
    owners = ["amazon"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-2.*-x86_64-gp2"]
    } 
  
}

output "ami_id" {
    value = data.aws_ami.ubuntu.id
}
output "ami_id1" {
    value = data.aws_ami.amazon.id
}
  

  

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}