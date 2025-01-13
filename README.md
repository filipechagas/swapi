# Rails 8 + React Application

This application uses Rails 8 with React frontend, running in a Docker development environment. This guide will help you get started with development and testing.

## Prerequisites

- Docker Desktop (latest version)
- Git

No other dependencies are required as everything runs inside Docker containers!

## Getting Started

1. Clone the repository:

   ```bash
   git clone <your-repository-url>
   cd <repository-name>
   ```

2. Start the application:

   ```bash
   docker compose up
   ```

   This command will:

   - Build the Docker image
   - Install all dependencies (Ruby gems and npm packages)
   - Start the Rails server, JavaScript compiler, and background jobs
   - Set up the development database

3. Access the application at `http://localhost:3000`

## Development

### Running Commands

To run commands in the Docker environment, prefix them with `docker compose run --rm web`. For example:

# Access Rails console

docker compose run --rm web rails console

````

### Database Operations

```bash
# Create database
docker compose run --rm web rails db:create

# Run migrations
docker compose run --rm web rails db:migrate

# Seed database
docker compose run --rm web rails db:seed
````

## Testing

### Running Unit Tests

To run the full test suite:

```bash
docker compose run --rm -e RAILS_ENV=test web rails test
```

To run a specific test file:

```bash
docker compose run --rm -e RAILS_ENV=test web rails test test/models/user_test.rb
```

### Running System Tests

For system tests (end-to-end tests), use:

```bash
# Run all system tests
docker compose run --rm -e RAILS_ENV=test web rails test test/system/

# Run a specific system test file
docker compose run --rm -e RAILS_ENV=test web rails test test/system/users_test.rb
```

Note: System tests use Selenium and Chrome in headless mode inside the Docker container.

### Test Environment Setup

Before running tests for the first time:

```bash
# Prepare test database
docker compose run --rm -e RAILS_ENV=test web rails db:test:prepare
```

## Troubleshooting

### Common Issues

1. **Port already in use**

   ```bash
   docker compose down
   # Then try starting again
   docker compose up
   ```

2. **Stale dependencies**

   ```bash
   # Rebuild the containers
   docker compose build --no-cache
   docker compose up
   ```

3. **Database issues**

   ```bash
   # Reset the database
   docker compose run --rm web rails db:reset
   ```

4. **Node modules issues**
   ```bash
   # Remove node_modules volume and rebuild
   docker compose down -v
   docker compose up --build
   ```

### Cleaning Up

To remove all containers and volumes:

```bash
docker compose down -v
```

## Project Structure

- `/app/javascript/` - React components and frontend code
- `/app/controllers/` - Rails controllers
- `/app/models/` - ActiveRecord models
- `/test/` - Test files
  - `/test/models/` - Model tests
  - `/test/controllers/` - Controller tests
  - `/test/system/` - System tests (E2E)

## Docker Commands Reference

```bash
# Start the application
docker compose up

# Start in detached mode
docker compose up -d

# View logs
docker compose logs -f

# Stop the application
docker compose down

# Rebuild containers
docker compose up --build

# Run a one-off command
docker compose run --rm web <command>
```

## Contributing

1. Create a new branch for your feature
2. Make your changes
3. Run the test suite
4. Submit a pull request

## Additional Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [React Documentation](https://react.dev/)
- [Docker Documentation](https://docs.docker.com/)
