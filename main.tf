
resource "aws_instance" "jenkins" {
  ami           = var.web_server_ami
  instance_type = var.web_server_instance_type
  key_name      = "MyKeyPair"

  vpc_security_group_ids = [aws_default_security_group.default.id]

  user_data = <<-EOF
                #!/bin/bash
                # Update the system
                yum update -y
                
                # Add Jenkins repo
                wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
                
                # Import Jenkins-CI key
                rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
                
                # Upgrade packages
                yum upgrade -y
                
                # Check Amazon Linux version and install Java accordingly
                if grep -q 'Amazon Linux 2' /etc/system-release; then
                    amazon-linux-extras install java-openjdk11 -y
                elif grep -q 'Amazon Linux 2023' /etc/system-release; then
                    dnf install java-11-amazon-corretto -y
                fi
                
                # Install Jenkins
                yum install jenkins -y
                
                # Enable and start Jenkins service
                systemctl enable jenkins
                systemctl start jenkins

              EOF

  tags = {
    Name = "jenkins"
  }
}



# resource "aws_instance" "tomcat" {
#   ami           = var.web_server_ami
#   instance_type = var.web_server_instance_type
#   key_name      = "MyKeyPair"

#   vpc_security_group_ids = [aws_default_security_group.default.id]


#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo yum update -y
#                 sudo yum install -y java-1.8.0-openjdk
#                 wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz
#                 tar -xvf apache-tomcat-9.0.41.tar.gz
#                 sudo mv apache-tomcat-9.0.41 /usr/local/tomcat9
#                 sudo useradd -r tomcat
#                 sudo chown -R tomcat:tomcat /usr/local/tomcat9
#                 sudo tee /etc/systemd/system/tomcat.service<<EOF
#                 [Unit]
#                 Description=Tomcat Server
#                 After=syslog.target network.target
#                 [Service]
#                 Type=forking
#                 User=tomcat
#                 Group=tomcat
#                 Environment=CATALINA_HOME=/usr/local/tomcat9
#                 Environment=CATALINA_BASE=/usr/local/tomcat9
#                 Environment=CATALINA_PID=/usr/local/tomcat9/temp/tomcat.pid
#                 ExecStart=/usr/local/tomcat9/bin/catalina.sh start
#                 ExecStop=/usr/local/tomcat9/bin/catalina.sh stop
#                 RestartSec=12
#                 Restart=always
#                 [Install]
#                 WantedBy=multi-user.target
#                 sudo systemctl daemon-reload
#                 sudo systemctl start tomcat
#                 EOF

#   tags = {
#     Name = "tomcat"
#   }
# }


# resource "aws_instance" "sonarqube" {
#   ami           = var.web_server_ami
#   instance_type = var.web_server_instance_type
#   key_name      = "MyKeyPair"

#   vpc_security_group_ids = [aws_default_security_group.default.id]

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install -y java-11-openjdk wget unzip
#               wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.5.zip
#               unzip sonarqube-7.9.5.zip
#               sudo mv sonarqube-7.9.5 /opt/sonarqube
#               sudo bash -c "echo 'sonar.jdbc.username=sonar' >> /opt/sonarqube/conf/sonar.properties"
#               sudo bash -c "echo 'sonar.jdbc.password=sonar' >> /opt/sonarqube/conf/sonar.properties"
#               sudo bash -c "echo 'sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube' >> /opt/sonarqube/conf/sonar.properties"
#               sudo adduser sonar
#               sudo chown -R sonar:sonar /opt/sonarqube
#               sudo bash -c 'echo "sonar   -   nofile   65536" >> /etc/security/limits.d/99-sonarqube.conf'
#               sudo bash -c 'echo "sonar   -   nproc    4096" >> /etc/security/limits.d/99-sonarqube.conf'
#               sudo bash -c 'echo "vm.max_map_count=262144" >> /etc/sysctl.d/99-sonarqube.conf'
#               sudo sysctl --system
#               sudo systemctl start sonarqube
#               EOF

#   tags = {
#     Name = "SonarQube-Server"
#   }
# }


