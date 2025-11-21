FROM tomcat:9-jre11

# Xóa apps mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# COPY ĐÚNG TÊN FILE và đổi thành ROOT.war
COPY target/webapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]