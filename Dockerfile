FROM tomcat:latest
RUN cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps
COPY ./app.war /usr/local/tomcat/webapps/ROOT.war  
EXPOSE 8080
CMD ["catalina.sh", "run"]
