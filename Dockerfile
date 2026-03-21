# ============================================================
# Stage 1: Build — Compile all Java source files
# ============================================================
FROM tomcat:10.1-jdk17-temurin AS builder

WORKDIR /build

# Copy all source files
COPY src/ /build/src/
COPY WebContent/ /build/WebContent/

# Compile all Java servlets using Tomcat's built-in servlet-api (jakarta.*)
# This ensures the classes match Tomcat 10.1 (Jakarta EE namespace)
RUN find /build/src -name "*.java" > /build/sources.txt && \
    javac \
      -cp "/usr/local/tomcat/lib/servlet-api.jar:/build/WebContent/WEB-INF/lib/*" \
      -d /build/WebContent/WEB-INF/classes \
      @/build/sources.txt

# ============================================================
# Stage 2: Run — Deploy compiled app into Tomcat
# ============================================================
FROM tomcat:10.1-jdk17-temurin

# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy compiled WebContent (includes freshly compiled .class files)
COPY --from=builder /build/WebContent /usr/local/tomcat/webapps/ROOT

# Copy extra JAR files to Tomcat lib (optional, Tomcat servlet-api is already included)
COPY WebContent/WEB-INF/lib/*.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Create database directory (for SQLite fallback / local dev)
RUN mkdir -p /usr/local/tomcat/database && chmod 777 /usr/local/tomcat/database

# Expose port (Render overrides this with $PORT env var)
EXPOSE 8080

# Dynamically bind Tomcat to Render's $PORT and start
CMD ["bash", "-c", "sed -i 's/port=\"8080\"/port=\"'\"${PORT:-8080}\"'\"/' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
