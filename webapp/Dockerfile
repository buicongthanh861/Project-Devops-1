FROM tomcat:latest

# Xóa webapp ROOT mặc định và copy các webapp khác
RUN rm -rf /usr/local/tomcat/webapps/ROOT && \
    cp -R /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps

# Copy ứng dụng của bạn
COPY target/webapp.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]