
resource "aws_launch_template" "mid-server-ec2-lt" {
  count         = var.instance_object.ec2_count
  name_prefix   = "${var.account_name}-${var.instance_object.name_prefix}-launch-template-${count.index + 1}"
  instance_type = var.instance_object.sku
  image_id      = var.ami_windows_id
  key_name      = var.key_pair_name

  /*block_device_mappings {
    device_name = var.instance_object.volume.device_name
    ebs {
      encrypted   = true
      volume_size = var.instance_object.volume.aws_ebs_volume
      volume_type = var.instance_object.volume.type
      #delete_on_termination = true
    }

  }*/

  iam_instance_profile {
    name = var.instance_profile
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.nsg_id]
    delete_on_termination       = true
    subnet_id                   = lower(var.instance_object.zone_2) == "yes" ? var.subnet_id_2 : var.subnet_id
  }

  lifecycle {
    create_before_destroy = true
  }

  /*metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_protocol_ipv6          = "disabled"
    instance_metadata_tags      = "disabled"
    http_put_response_hop_limit = 2
  }*/

  tag_specifications {
    resource_type = "instance"
    tags = merge({
      Name = "${var.account_name}-${var.instance_object.name_prefix}-win-${count.index + 1}"

      },
      var.tags
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge({
      "Name" = "${var.account_name}-${var.instance_object.name_prefix}-root-disk-${count.index + 1}"
      },

      var.tags
    )
  }

  tags = var.tags

  user_data = base64encode(var.template_sshd)

  update_default_version = true


}

resource "aws_autoscaling_group" "mid-server-asg" {
  count       = var.instance_object.ec2_count
  name_prefix = "${var.account_name}-${var.instance_object.name_prefix}-asg-${count.index + 1}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  desired_capacity     = var.mid_server_desired_capacity
  max_size             = var.mid_server_max_capacity
  min_size             = var.mid_server_min_capacity
  termination_policies = ["ClosestToNextInstanceHour"]
  #vpc_zone_identifier  = [var.subnet_id]
  availability_zones = [lower(var.instance_object.zone_2) == "yes" ? var.availability_zone_2 : var.availability_zone_1]
  launch_template {
    id      = aws_launch_template.mid-server-ec2-lt[count.index].id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity, min_size, max_size]
  }

  initial_lifecycle_hook {
    name                 = "${var.account_name}-${var.instance_object.name_prefix}-lifecycle"
    default_result       = "CONTINUE"
    heartbeat_timeout    = var.mid-server-lifecycle-termination-heartbeat-timeout
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    #    role_arn                = aws_iam_role.lifecycle_hook.arn
  }

  /*dynamic "tag" {
    for_each = concat(
      data.null_data_source.asg-name-tag.*.outputs,
      data.null_data_source.asg-tags.*.outputs,
    )
    content {
      key                 = tag.value["key"]
      value               = tag.value["value"]
      propagate_at_launch = true
    }
  }*/

  force_delete = true
  depends_on   = [aws_launch_template.mid-server-ec2-lt]
}
