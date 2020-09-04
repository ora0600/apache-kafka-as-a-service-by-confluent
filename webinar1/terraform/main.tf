# VPC
resource "aws_vpc" "vpc_rss_cmutzlitz" {
  cidr_block = "10.10.1.0/24"
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-rss-cmutzlitz"
    owner = "cmutzlitz@confluent.io"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "cmutzlitz_rss_ig" {
    vpc_id = "${aws_vpc.vpc_rss_cmutzlitz.id}"
}

# Public Subnet
resource "aws_subnet" "cmutzlitz_rss_subnet1_public" {
  vpc_id     = "${aws_vpc.vpc_rss_cmutzlitz.id}"
  cidr_block = "10.10.1.0/24"
  availability_zone = "eu-central-1c"
  tags = {
    Name = "cmutzlitz_rss_subnet1_public"
    owner = "cmutzlitz@confluent.io"
  }
}

resource "aws_route_table" "cmutzlitz_rss_subnet1_public-route" {
    vpc_id = "${aws_vpc.vpc_rss_cmutzlitz.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.cmutzlitz_rss_ig.id}"
    }
    tags = {
    Name = "cmutzlitz_rss_subnet1_public-route"
    }
}

resource "aws_route_table_association" "cmutzlitz_subnet1_public_dmz" {
    subnet_id = "${aws_subnet.cmutzlitz_rss_subnet1_public.id}"
    route_table_id = "${aws_route_table.cmutzlitz_rss_subnet1_public-route.id}"
}


resource "aws_security_group" "rss_connect" {
  name        = "SecGroupConfluentCloudRSSConnect"
  description = "Security Group for Confluent RSSConnect with Confluent Cloud setup"
  vpc_id      = aws_vpc.vpc_rss_cmutzlitz.id
  
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "rss-connect" {
  count             = var.instance_count
  ami               = "${data.aws_ami.ami.id}"
  instance_type     = var.instance_type_resource
  key_name          = var.ssh_key_name
  vpc_security_group_ids = ["${aws_security_group.rss_connect.id}"]
  subnet_id         = "${aws_subnet.cmutzlitz_rss_subnet1_public.id}"
  associate_public_ip_address = true
  user_data = data.template_file.confluent_instance.rendered
  
  root_block_device {
      volume_type = "gp2"
      volume_size = 50
      delete_on_termination = true
  }
  provisioner "file" {
    source      = "../consumer_rssfeeds.py"
    destination = "/home/ec2-user/consumer_rssfeeds.py"
    connection {
       type        = "ssh"
       user        = "ec2-user"
       private_key = file("~/keys/hackathon-temp-key.pem")
       host        = self.public_ip
    }
  }
  provisioner "file" {
    source      = "../ccloud_lib_rssfeeds.py"
    destination = "/home/ec2-user/ccloud_lib_rssfeeds.py"
    connection {
       type        = "ssh"
       user        = "ec2-user"
       private_key = file("~/keys/hackathon-temp-key.pem")
       host        = self.public_ip
    }
  }
  provisioner "file" {
    source      = "../ccloud.config"
    destination = "/home/ec2-user/ccloud.config"
    connection {
       type        = "ssh"
       user        = "ec2-user"
       private_key = file("~/keys/hackathon-temp-key.pem")
       host        = self.public_ip
    }
  }

  
  tags = {
    name = "rss-connect"
    deployed_with = "terraform"
    owner = "cmutzlitz@confluent.io"
  }
}

