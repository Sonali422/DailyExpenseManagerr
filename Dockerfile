FROM tomcat:10.1-jdk17-temurin

# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WebContent to ROOT
COPY WebContent /usr/local/tomcat/webapps/ROOT

# Copy necessary external JARs to lib
COPY servlet-api.jar /usr/local/tomcat/lib/
COPY WebContent/WEB-INF/lib/*.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Create directory for the database
RUN mkdir -p /usr/local/tomcat/database && chmod 777 /usr/local/tomcat/database

# Set environment variable for the database path
ENV SQLITE_DB_PATH=/usr/local/tomcat/database/expense_db.db

# VOLUME for persistent storage
VOLUME /usr/local/tomcat/database

EXPOSE 8080

CMD ["catalina.sh", "run"]
