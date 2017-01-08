resource "aws_instance" "SbxBoxWeb" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.Sbx-Public-SSH.id}"]

  # the public SSH key
  key_name = "${aws_key_pair.mykeypair.key_name}"
}

#ADD EBS VOLUME
resource "aws_ebs_volume" "ebs-volume-1" {
    availability_zone = "eu-west-1a"
    size = 20
    type = "gp2"
    tags {
        Name = "extra volume data"
    }
}

#ATTACHING VOLUME
resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id = "${aws_instance.SbxBoxWeb.id}"
}