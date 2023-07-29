output "sonarqube_public_ip" {
  value       = aws_instance.sonarqube.public_ip
  description = "Public IP of the SonarQube instance"
}

output "sonarqube_public_dns" {
  value       = aws_instance.sonarqube.public_dns
  description = "Public DNS of the SonarQube instance"
}

output "jenkins_public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "Public IP of the Jenkins instance"
}

output "jenkins_public_dns" {
  value       = aws_instance.jenkins.public_dns
  description = "Public DNS of the Jenkins instance"
}

output "tomcat_public_ip" {
  value       = aws_instance.tomcat.public_ip
  description = "Public IP of the Tomcat instance"
}

output "tomcat_public_dns" {
  value       = aws_instance.tomcat.public_dns
  description = "Public DNS of the Tomcat instance"
}
