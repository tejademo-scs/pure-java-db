FROM openjdk:8 AS Build
RUN  apt update && apt install maven -y && apt install git -y 
RUN git clone https://github.com/Teja-Chittamuri/Devops-JavaE2EProject.git
RUN  cd Devops-JavaE2EProject && mvn clean install 
FROM tomcat:8-jre11
RUN rm -rf  /usr/local/tomcat/webapps/*
COPY --from=Build Devops-JavaE2EProject/webapp/target/*.war  /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
ENTRYPOINT ["catalina.sh","run"]

