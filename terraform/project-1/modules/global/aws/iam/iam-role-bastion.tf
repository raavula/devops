#SSP - shirdi sai parivar
#
# IAM Policy for Bastion
#
resource "aws_iam_policy" "bastion_policy" {
  name = "SSPBastionPolicy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudwatchLogAllow",
      "Action": [
        "ec2:Describe*",
        "cloudwatch:*",
        "logs:*",
        "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  lifecycle { create_before_destroy = true }
}

#
# IAM role for Bastion
#
resource "aws_iam_role" "bastion_role" {
  name = "SSPBastionRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AssumeRoleAllow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  lifecycle { create_before_destroy = true }
}

#
# IAM policy attachment for Bastion
#
resource "aws_iam_policy_attachment" "bastion_policy_attach" {
  name       = "SSPBastionPolicyAttachment"
  roles      = ["${aws_iam_role.bastion_role.name}"]
  policy_arn = "${aws_iam_policy.bastion_policy.arn}"

  lifecycle { create_before_destroy = true }
}

#
# IAM instance profile for Bastion
#
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "SSPBastionInstanceProfile"
  roles = ["${aws_iam_role.bastion_role.name}"]

  lifecycle { create_before_destroy = true }
}


output "bastion_instance_profile" {
  value = "${aws_iam_instance_profile.bastion_instance_profile.name}"
}
