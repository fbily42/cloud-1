output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = [for instance in aws_instance.cloud1 : instance.id]
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = [for instance in aws_instance.cloud1 : instance.public_ip]
}
