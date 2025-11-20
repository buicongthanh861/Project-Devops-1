FROM tomcat:latest

# Copy Tomcat users configuration
COPY tomcat-users.xml /usr/local/tomcat/conf/

# Copy context.xml for manager app
COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/

# Copy WAR file to webapps 
COPY ./app.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
