# Database Setup

This directory contains files for setting up the PostgreSQL tickets database locally using Docker.

## Quick Start

1. Start the database:
   ```bash
   docker-compose up -d
   ```

2. Verify the setup:
   ```bash
   docker exec -it tickets-db psql -U postgres -d ticketsdb -c "SELECT COUNT(*) FROM tickets;"
   ```

3. Stop the database:
   ```bash
   docker-compose down
   ```

## Files

- `docker-compose.yml` - Docker Compose configuration for PostgreSQL
- `init-db.sql` - Database schema and sample data initialization script

## Connection Details

- **Host**: localhost
- **Port**: 5432
- **Database**: ticketsdb
- **Username**: postgres
- **Password**: admin

## Manual Setup (Alternative)

If you prefer to set up PostgreSQL manually instead of using Docker, follow the original instructions in the main README.md file.

## Environment Variables for MCP Toolbox

When using the MCP Toolbox, update your `deployment/mcp-toolbox/tools.yaml` file to point to this database:

```yaml
sources:
  postgresql:
    kind: postgres
    host: 127.0.0.1
    port: 5432
    database: ticketsdb
    user: ${DB_USER}
    password: ${DB_PASS}
```

Set the environment variables:
```bash
export DB_USER=postgres
export DB_PASS=admin
```
