#!/bin/bash
set -e

echo "Ensuring Java is available..."
java -version || { echo "Java is not installed! Please install Java."; exit 1; }

echo "Downloading Jakarta Servlet API for compilation..."
if [ ! -f "servlet-api.jar" ]; then
    curl -L "https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar" -o servlet-api.jar
fi

echo "Downloading SQLite JDBC..."
mkdir -p WebContent/WEB-INF/lib
if [ ! -f "WebContent/WEB-INF/lib/sqlite-jdbc.jar" ]; then
    curl -L "https://repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.45.1.0/sqlite-jdbc-3.45.1.0.jar" -o WebContent/WEB-INF/lib/sqlite-jdbc.jar
fi

echo "Downloading SLF4J..."
if [ ! -f "WebContent/WEB-INF/lib/slf4j-api.jar" ]; then
    curl -L "https://repo1.maven.org/maven2/org/slf4j/slf4j-api/2.0.9/slf4j-api-2.0.9.jar" -o WebContent/WEB-INF/lib/slf4j-api.jar
fi
if [ ! -f "WebContent/WEB-INF/lib/slf4j-simple.jar" ]; then
    curl -L "https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/2.0.9/slf4j-simple-2.0.9.jar" -o WebContent/WEB-INF/lib/slf4j-simple.jar
fi

echo "Compiling Java sources..."
mkdir -p WebContent/WEB-INF/classes
javac -cp "servlet-api.jar:WebContent/WEB-INF/lib/*" -d WebContent/WEB-INF/classes $(find src -name "*.java")

echo "Setting up Tomcat 10..."
export TOMCAT_VERSION="10.1.20"
if [ ! -d "apache-tomcat-${TOMCAT_VERSION}" ]; then
    curl -O "https://archive.apache.org/dist/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
    tar -xzf "apache-tomcat-${TOMCAT_VERSION}.tar.gz"
    rm "apache-tomcat-${TOMCAT_VERSION}.tar.gz"
fi

echo "Deploying application to Tomcat..."
rm -rf "apache-tomcat-${TOMCAT_VERSION}/webapps/ROOT"
cp -r WebContent "apache-tomcat-${TOMCAT_VERSION}/webapps/ROOT"

echo "=========================================="
echo "Application ready. Starting Tomcat server!"
echo "You can access it at http://localhost:8080"
echo "=========================================="

chmod +x apache-tomcat-${TOMCAT_VERSION}/bin/*.sh
mkdir -p ./sqlite_temp
# Use a fresh temp dir for SQLite to avoid native library conflicts
export CATALINA_OPTS="$CATALINA_OPTS -Dorg.sqlite.tmpdir=$(pwd)/sqlite_temp"
./apache-tomcat-${TOMCAT_VERSION}/bin/catalina.sh run
