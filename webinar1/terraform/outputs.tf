###########################################
################# Outputs #################
###########################################

output "SSH" {
  value = tonumber(var.instance_count) >= 1 ? "SSH  Access: ssh -i ~/keys/hackathon-temp-key.pem ec2-user@${join(",",formatlist("%s", aws_instance.rss-connect.*.public_ip),)} " : "Confluent Cloud Platform on AWS is disabled" 
}
