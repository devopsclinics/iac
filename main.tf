
resource "aws_instance" "jenkins" {
  ami           = var.web_server_ami
  instance_type = var.web_server_instance_type
  key_name      = "MyKeyPair"

  vpc_security_group_ids = [aws_default_security_group.default.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install openjdk-17-jre -y
                curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
                  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
                echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                  /etc/apt/sources.list.d/jenkins.list > /dev/null
                sudo apt-get update
                sudo apt-get install jenkins
              EOF

  tags = {
    Name = "jenkins"
  }
}



resource "aws_instance" "tomcat" {
  ami           = var.web_server_ami
  instance_type = var.web_server_instance_type
  key_name      = "MyKeyPair"

  vpc_security_group_ids = [aws_default_security_group.default.id]

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install openjdk-17-jre -y
                wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz
                tar -xvf apache-tomcat-9.0.41.tar.gz
                sudo mv apache-tomcat-9.0.41 /usr/local/tomcat9
                sudo useradd -r tomcat
                sudo chown -R tomcat:tomcat /usr/local/tomcat9
                sudo tee /etc/systemd/system/tomcat.service<<EOF
                [Unit]
                Description=Tomcat Server
                After=syslog.target network.target
                [Service]
                Type=forking
                User=tomcat
                Group=tomcat
                Environment=CATALINA_HOME=/usr/local/tomcat9
                Environment=CATALINA_BASE=/usr/local/tomcat9
                Environment=CATALINA_PID=/usr/local/tomcat9/temp/tomcat.pid
                ExecStart=/usr/local/tomcat9/bin/catalina.sh start
                ExecStop=/usr/local/tomcat9/bin/catalina.sh stop
                RestartSec=12
                Restart=always
                [Install]
                WantedBy=multi-user.target
                sudo systemctl daemon-reload
                sudo systemctl start tomcat
              EOF

  tags = {
    Name = "tomcat"
  }
}


resource "aws_instance" "sonarqube" {
  ami           = var.web_server_ami
  instance_type = var.web_server_instance_type
  key_name      = "MyKeyPair"

  vpc_security_group_ids = [aws_default_security_group.default.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y openjdk-11-jdk wget unzip
              wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.5.zip
              unzip sonarqube-7.9.5.zip
              sudo mv sonarqube-7.9.5 /opt/sonarqube
              sudo bash -c "echo 'sonar.jdbc.username=sonar' >> /opt/sonarqube/conf/sonar.properties"
              sudo bash -c "echo 'sonar.jdbc.password=sonar' >> /opt/sonarqube/conf/sonar.properties"
              sudo bash -c "echo 'sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube' >> /opt/sonarqube/conf/sonar.properties"
              sudo bash -c "echo 'sonar.web.javaAdditionalOpts=-server' >> /opt/sonarqube/conf/sonar.properties"
              sudo adduser sonar
              sudo chown -R sonar:sonar /opt/sonarqube
              sudo bash -c 'echo "sonar   -   nofile   65536" >> /etc/security/limits.d/99-sonarqube.conf'
              sudo bash -c 'echo "sonar   -   nproc    4096" >> /etc/security/limits.d/99-sonarqube.conf'
              sudo bash -c 'echo "vm.max_map_count=262144" >> /etc/sysctl.d/99-sonarqube.conf'
              sudo sysctl --system
              sudo su - sonar -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"
              EOF

  tags = {
    Name = "SonarQube-Server"
  }
}


