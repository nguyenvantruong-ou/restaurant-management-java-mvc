# Use Tomcat 9 with OpenJDK 17
FROM tomcat:9.0-jdk17-openjdk-slim

# Set working directory
WORKDIR /usr/local/tomcat

# Remove default Tomcat webapps
RUN rm -rf webapps/*

# Copy Maven wrapper and pom.xml for dependency caching (optional optimization)
COPY RestaurantManagement/pom.xml /tmp/pom.xml

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

# Copy project source
COPY RestaurantManagement /tmp/RestaurantManagement

# Build the WAR file
WORKDIR /tmp/RestaurantManagement
# Set MAVEN_OPTS to open Java modules for EclipseLink and other libraries
ENV MAVEN_OPTS="--add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.text=ALL-UNNAMED --add-opens java.desktop/java.awt.font=ALL-UNNAMED"
RUN mvn clean package -DskipTests

# Copy the built WAR file to Tomcat webapps directory
RUN cp target/*.war /usr/local/tomcat/webapps/ROOT.war && \
    mkdir -p /usr/local/tomcat/webapps/ROOT && \
    cd /usr/local/tomcat/webapps/ROOT && \
    jar -xf ../ROOT.war

# Install netcat and MySQL client for database health check
RUN apt-get update && \
    apt-get install -y netcat-openbsd default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint script, init.sql, and seeder.sql
COPY docker-entrypoint.sh /usr/local/bin/
COPY init.sql /init.sql
COPY seeder.sql /seeder.sql
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose port 8080
EXPOSE 8080

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

