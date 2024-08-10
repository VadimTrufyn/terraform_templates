data "aws_ami" "ubuntu" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_security_group" "web_sec_group" {
  name = "web_sec_group"
  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "web_sec_group"
  }
}

resource "aws_launch_configuration" "as_conf" {
  name = "web-server-ha"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sec_group.id]
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "web-asg"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 2
  max_size             = 2
  desired_capacity     = 2  # Додано для визначення бажаного розміру
  vpc_zone_identifier  = [
    aws_default_subnet.subnet-az-1.id, 
    aws_default_subnet.subnet-az-2.id
  ]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.truefunny.name]

  tag {
    key                 = "Name"
    value               = "web-server-ha"
    propagate_at_launch = true
  }

  tag {
    key                 = "owners"
    value               = "noble"
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = "web-server-ha"
    propagate_at_launch = true
  }
}

    


resource "aws_elb" "truefunny" {
   name = "truefunny"
   security_groups = [ aws_security_group.web_sec_group.id ]
   availability_zones = [ data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1] ]
   listener {
     instance_port = 80
     instance_protocol = "http"
     lb_port = 80
     lb_protocol = "http"
   }
   health_check {
     healthy_threshold = 2
     unhealthy_threshold = 2
     timeout = 3
     interval = 30
     target = "HTTP:80/"
   }
   tags = {
     Name = "truefunny"
   }
  }
 
 resource "aws_default_subnet" "subnet-az-1" {
    availability_zone = data.aws_availability_zones.available.names[0]
 }

 resource "aws_default_subnet" "subnet-az-2" {
    availability_zone = data.aws_availability_zones.available.names[1]
 }


output "dns_name" {
    value = aws_elb.truefunny.dns_name
}
  

   
 