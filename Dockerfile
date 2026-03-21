FROM tomcat:10.1-jdk17-temurin

# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WebContent to ROOT
COPY WebContent /usr/local/tomcat/webapps/ROOT

# Copy necessary external JARs to lib
COPY servlet-api.jar /usr/local/tomcat/lib/
COPY WebContent/WEB-INF/lib/*.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Create directory for the database (kept for local/fallback use)
RUN mkdir -p /usr/local/tomcat/database && chmod 777 /usr/local/tomcat/database

# Expose port (Render ignores EXPOSE, but good for documentation)
EXPOSE 8080

# Script to set the port in server.xml dynamically and start Tomcat
CMD ["bash", "-c", "sed -i 's/port=\"8080\"/port=\"'\"${PORT:-8080}\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
