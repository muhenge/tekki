# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

- **Install Ruby dependencies**: `bundle install` (run from the repository root).
- **Install JavaScript dependencies**: `npm install`.
- **Database setup**: `bin/rails db:create db:migrate db:seed`.
- **Start the API server**: `bin/rails server` (default at `http://localhost:3000`).
- **Run the test suite**: `bundle exec rspec`. To run a single spec file: `bundle exec rspec spec/path/to/file_spec.rb`.
- **Run a single test example**: `bundle exec rspec spec/path/to/file_spec.rb:LINE_NUMBER`.
- **Lint / static analysis**: `bundle exec rubocop` (if RuboCop is configured).
- **Docker build & run**:
  ```bash
  docker build -t teki .
  docker run -p 3000:3000 --env-file .env teki
  ```
- **Fly.io deployment** (recommended):
  ```bash
  fly auth login
  fly deploy
  # Run migrations on Fly
  fly ssh console -C "bin/rails db:migrate db:seed"
  ```
- **Kamal (self‑hosted) deployment**:
  ```bash
  ./setup_kamal.sh   # sets up environment & SSH keys
  kamal setup
  kamal deploy
  kamal app exec bin/rails db:migrate db:seed
  ```

## High‑Level Architecture

- **Framework**: Ruby on Rails 8 (API mode) – all HTTP endpoints are under `/api` and respond with JSON.
- **Authentication**: Devise with `devise-jwt` for stateless JWT tokens. OAuth providers (Google, Microsoft, Apple) are wired via OmniAuth.
- **Core Resources**:
  - `User` (model `app/models/user.rb`) – handles authentication, profile, avatar (Active Storage), follows (self‑referential `Relationship`), and associated `Career`, `Post`, `Skill`, `Comment`.
  - `Post` – user‑generated content; supports voting (`like` action) and is searchable (`/api/posts/search`).
  - `Comment`, `Skill`, `Career`, `Relationship` – auxiliary resources linked through standard Rails associations.
- **API Documentation**: RSwag provides Swagger UI at `/api-docs` (both local and production).
- **Background Jobs**: Sidekiq is included in the Gemfile but not heavily used yet; job classes live in `app/jobs`.
- **File Uploads**: Active Storage with MiniMagick for image processing; avatars are attached to `User`.
- **Routing**: Defined in `config/routes.rb`. Namespaced under `api`, with a separate `auth` namespace for JWT and OAuth endpoints, and resourceful routes for users, posts, comments, skills, careers, and relationships.
- **Testing**: RSpec is the test framework (`spec/` folder). Factory Bot and Shoulda matchers are available via the Gemfile.
- **Configuration**:
  - Environment variables are loaded from `.env` (see README section “Environment Variables”).
  - Database configuration in `config/database.yml` (PostgreSQL, Neon in production).
  - CORS handling via `rack-cors` gem.
  - Deployments use Fly.io (default) or Kamal for self‑hosted servers.
- **Containerisation**: Dockerfile present at the repo root for building a container image.

## Notable Files & Directories

- `app/models/` – domain entities.
- `app/controllers/api/` – API controllers, each matching a resource.
- `app/views/` – Jbuilder view templates for JSON responses.
- `config/initializers/` – Rails initializer files (e.g., Devise, JWT, CORS).
- `spec/` – RSpec test suite.
- `Dockerfile` & `docker-entrypoint` – container setup.
- `fly.toml` – Fly.io configuration.
- `setup_kamal.sh` – script to bootstrap Kamal deployment.

## Development Tips

- Use `bin/rails console` for an interactive REPL with the application context.
- Run `bin/rails routes` to see the full list of endpoints.
- Swagger UI (`http://localhost:3000/api-docs`) provides live API documentation and request examples.
- For credential management, keep secrets in `config/credentials.yml.enc` and load them via `Rails.application.credentials`.
- When adding new API endpoints, follow the existing pattern: controller under `app/controllers/api/`, routes in `config/routes.rb`, Jbuilder view in `app/views/api/` if custom JSON output is needed, and corresponding specs in `spec/`.
