
# locals.tf
locals {
    instances = {
        jenkins_master = {
            template_name = "Jenkins_master"
            ami_id       = "ami-06f569db16f77195d"
        }
        jenkins_slave = {
            template_name = "Jenkins_slave"
            ami_id       = "ami-0175c1cdf8e977ea4"
        }
         
ansible_controller_f_jenkins_slave2 = {
            template_name = "ansible_controller_f_jenkins_slave2"
            ami_id       = "ami-0eafc31cd03d50275"
        }
    }

    common_tags = {
        Environment = "development"
        Managed_by  = "terraform"
    }
}

# security.tf
resource "aws_security_group" "allow_all" {
    name_prefix = "allow_all_traffic"
    description = "Allow all inbound and outbound traffic"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(local.common_tags, {
        Name = "allow_all_traffic"
    })
}

# jenkins.tf
data "aws_launch_template" "templates" {
    for_each = local.instances
    name     = each.value.template_name
}

resource "aws_instance" "jenkins_instances" {
    for_each = local.instances

    ami           = each.value.ami_id
    instance_type = data.aws_launch_template.templates[each.key].instance_type

    launch_template {
        id      = data.aws_launch_template.templates[each.key].id
        version = "$Latest"
    }

    tags = merge(local.common_tags, {
        Name = each.key
    })
}

