FROM tomcat:latest

# Copy webapps.dist trước
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps

# Copy WAR file trực tiếp từ target/ 
COPY ./target/webapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]