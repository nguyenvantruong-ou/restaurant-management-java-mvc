#!/bin/bash
set -e

# Wait for database to be ready
echo "Waiting for database to be ready..."
until nc -z ${DB_HOST:-db} ${DB_PORT:-3306}; do
  echo "Database is unavailable - sleeping"
  sleep 1
done
echo "Database port is open, waiting for MySQL to be ready..."
# Wait for MySQL to be fully ready (check if we can connect to MySQL server)
max_attempts=30
attempt=0
until mysql -h${DB_HOST:-db} -P${DB_PORT:-3306} -u${DB_USER:-root} -p${DB_PASSWORD:-12345678} -e "SELECT 1" >/dev/null 2>&1; do
  attempt=$((attempt + 1))
  if [ $attempt -ge $max_attempts ]; then
    echo "MySQL is not ready after $max_attempts attempts. Proceeding anyway..."
    break
  fi
  echo "MySQL is not ready yet (attempt $attempt/$max_attempts) - sleeping"
  sleep 2
done
echo "Database is up and ready - executing command"

# Ensure database exists (init.sql should have created it, but double-check)
mysql -h${DB_HOST:-db} -P${DB_PORT:-3306} -u${DB_USER:-root} -p${DB_PASSWORD:-12345678} -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME:-restaurantmanagement};" 2>/dev/null || true

# Check if tables exist, if not, create them
TABLE_COUNT=$(mysql -h${DB_HOST:-db} -P${DB_PORT:-3306} -u${DB_USER:-root} -p${DB_PASSWORD:-12345678} -D${DB_NAME:-restaurantmanagement} -se "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${DB_NAME:-restaurantmanagement}';" 2>/dev/null || echo "0")

if [ "$TABLE_COUNT" -eq "0" ] || [ -z "$TABLE_COUNT" ]; then
    echo "No tables found. Creating database schema from init.sql..."
    if [ -f /init.sql ]; then
        mysql -h${DB_HOST:-db} -P${DB_PORT:-3306} -u${DB_USER:-root} -p${DB_PASSWORD:-12345678} ${DB_NAME:-restaurantmanagement} < /init.sql 2>/dev/null && echo "Database schema created successfully." || echo "Warning: Could not create schema from init.sql"
    else
        echo "Warning: init.sql not found. Tables will be created by Hibernate auto-DDL."
    fi
else
    echo "Database schema already exists ($TABLE_COUNT tables found)."
fi

# Optionally run seeder if SEED_DATABASE environment variable is set to "true"
if [ "${SEED_DATABASE:-false}" = "true" ]; then
    echo "Running database seeder..."
    if [ -f /seeder.sql ]; then
        mysql -h${DB_HOST:-db} -P${DB_PORT:-3306} -u${DB_USER:-root} -p${DB_PASSWORD:-12345678} ${DB_NAME:-restaurantmanagement} < /seeder.sql 2>/dev/null && echo "Database seeded successfully." || echo "Warning: Could not seed database from seeder.sql"
    else
        echo "Warning: seeder.sql not found. Skipping database seeding."
    fi
fi

# Replace database properties with environment variables
mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes
cat > /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/database.properties <<EOF
hibernate.dialect = org.hibernate.dialect.MySQLDialect
hibernate.showSql = true
hibernate.connection.driverClass = com.mysql.cj.jdbc.Driver
hibernate.connection.url = jdbc:mysql://${DB_HOST:-db}:${DB_PORT:-3306}/${DB_NAME:-restaurantmanagement}?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&zeroDateTimeBehavior=CONVERT_TO_NULL
hibernate.connection.username = ${DB_USER:-root}
hibernate.connection.password = ${DB_PASSWORD:-12345678}
hibernate.hbm2ddl.auto = update
EOF

# Set CATALINA_OPTS to open Java modules for EclipseLink and other libraries at runtime
export CATALINA_OPTS="--add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.text=ALL-UNNAMED --add-opens java.desktop/java.awt.font=ALL-UNNAMED"

# Start Tomcat
exec catalina.sh run

