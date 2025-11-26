# Docker Setup Guide

This guide explains how to run the Restaurant Management application using Docker.

## Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose (usually included with Docker Desktop)

## Quick Start

1. **Build and start all services:**
   ```bash
   docker-compose up --build
   ```

2. **Run in detached mode (background):**
   ```bash
   docker-compose up -d --build
   ```

3. **Access the application:**
   - Application: http://localhost:8080
   - MySQL Database: localhost:3306

## Services

### Database (MySQL)
- **Container name:** `restaurant_db`
- **Port:** `3306`
- **Database:** `restaurantmanagement`
- **Root password:** `12345678`
- **User:** `restaurant_user`
- **Password:** `restaurant_pass`

### Application (Tomcat)
- **Container name:** `restaurant_app`
- **Port:** `8080`
- **Context path:** `/` (root)

## Environment Variables

You can customize the database connection by setting these environment variables in `docker-compose.yml`:

- `DB_HOST`: Database host (default: `db`)
- `DB_PORT`: Database port (default: `3306`)
- `DB_NAME`: Database name (default: `restaurantmanagement`)
- `DB_USER`: Database user (default: `root`)
- `DB_PASSWORD`: Database password (default: `12345678`)

## Common Commands

### Stop services
```bash
docker-compose down
```

### Stop and remove volumes (clean database)
```bash
docker-compose down -v
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f db
```

### Rebuild after code changes
```bash
docker-compose up --build
```

### Access database
```bash
# Using MySQL client
docker exec -it restaurant_db mysql -uroot -p12345678 restaurantmanagement

# Or using docker-compose
docker-compose exec db mysql -uroot -p12345678 restaurantmanagement
```

### Access application container shell
```bash
docker exec -it restaurant_app /bin/bash
```

## Database Persistence

The MySQL data is persisted in a Docker volume named `mysql_data`. This means your data will survive container restarts. To completely reset the database:

```bash
docker-compose down -v
docker-compose up -d
```

## Troubleshooting

### Application can't connect to database
- Ensure the database container is healthy: `docker-compose ps`
- Check database logs: `docker-compose logs db`
- Verify environment variables in `docker-compose.yml`

### Port already in use
- Change the port mappings in `docker-compose.yml` if ports 8080 or 3306 are already in use
- For example, change `"8080:8080"` to `"8081:8080"` for the app service

### Build fails
- Ensure you have enough disk space
- Try cleaning Docker: `docker system prune -a`
- Check Maven dependencies are accessible

## Development Workflow

1. Make code changes in `RestaurantManagement/`
2. Rebuild the application: `docker-compose up --build app`
3. The database persists between rebuilds

## Database Seeding

The application includes a seeder script (`seeder.sql`) that populates initial data:

- **Admin Account**: 
  - Username: `admin`
  - Password: The default password hash in seeder.sql (you should change this)
  - Role: `ADMIN`

- **Sample Lobbies**: 5 pre-configured lobbies with different prices and capacities
- **Sample Menus**: 8 pre-configured menu options

### Running the Seeder

The seeder runs automatically when `SEED_DATABASE=true` is set in `docker-compose.yml` (default: enabled).

To run the seeder manually:
```bash
docker-compose exec db mysql -uroot -p12345678 restaurantmanagement < seeder.sql
```

Or from your host machine:
```bash
docker exec -i restaurant_db mysql -uroot -p12345678 restaurantmanagement < seeder.sql
```

### Changing Admin Password

To change the admin password, you need to generate a BCrypt hash. You can:

1. Use an online BCrypt generator (search for "BCrypt hash generator")
2. Use Spring's BCryptPasswordEncoder in your Java code
3. Use the application's sign-up feature to create a new admin account

Then update the `user_password` field in `seeder.sql` with the new hash.

## Production Considerations

For production deployment, consider:
- Using environment-specific configuration files
- Setting strong database passwords
- Using Docker secrets for sensitive data
- Setting up proper backup strategies for the database volume
- Configuring reverse proxy (nginx) for the application
- Using health checks and restart policies
- **Disabling automatic seeding** by setting `SEED_DATABASE=false` in docker-compose.yml

