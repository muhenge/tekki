# Tekki API

A Rails 8.0 REST API for a professional social networking platform.

## 🌐 Live Deployment

**Production API**: https://teki-api.fly.dev

**Swagger Documentation**: https://teki-api.fly.dev/api-docs

## 📚 API Documentation

Interactive API documentation is available via Swagger UI at:

- **Production**: https://teki-api.fly.dev/api-docs
- **Local**: `http://localhost:3000/api-docs`

## 🚀 Quick Start

### Prerequisites
- Ruby 3.4.8
- PostgreSQL
- Node.js & npm

### Installation

```bash
# Install dependencies
bundle install
npm install

# Setup database
bin/rails db:create db:migrate db:seed

# Start server
bin/rails server
```

### Docker Deployment

```bash
# Build and run with Docker
docker build -t teki .
docker run -p 3000:3000 --env-file .env teki
```

## 🚀 Deployment Options

### Option 1: Fly.io (Recommended)

**Production API**: https://teki-api.fly.dev

#### 1. Install Fly CLI
```bash
curl -L https://fly.io/install.sh | sh
```

#### 2. Login to Fly.io
```bash
fly auth login
```

#### 3. Launch App
```bash
fly launch --no-deploy
```

#### 4. Set Database Secrets (Neon Database)
```bash
fly secrets set DB_USER=konnecta_db_owner
fly secrets set DB_PASS=npg_5HNaXkymPQ0D
fly secrets set DB_HOST=ep-polished-bird-a57xxlgo-pooler.us-east-2.aws.neon.tech
fly secrets set DB_PORT=5432
fly secrets set DB_PROD=konnecta_db
fly secrets set SECRET_KEY_BASE=$(bin/rails secret)
fly secrets set RAILS_MASTER_KEY=$(cat config/credentials/production.key)
```

#### 5. Deploy
```bash
fly deploy
```

#### 6. Run Migrations
```bash
fly ssh console -C "bin/rails db:migrate db:seed"
```

#### 7. Open Your App
```bash
fly open
```

### Option 2: Kamal (Self-Hosted)

For deploying to your own servers via SSH.

#### 1. Configure Deployment

Edit `config/deploy.yml` with your server details and domain.

#### 2. Setup Environment

```bash
chmod +x setup_kamal.sh
./setup_kamal.sh
```

#### 3. Set Registry Password

```bash
export KAMAL_REGISTRY_PASSWORD='your_docker_hub_token'
```

#### 4. Deploy

```bash
kamal setup
kamal deploy
```

#### 5. Run Migrations

```bash
kamal app exec bin/rails db:migrate db:seed
```

**Note**: Kamal requires:
- SSH access to your server(s)
- Docker installed on remote servers
- Docker Hub account for container registry

## 🔑 Authentication

The API uses JWT (JSON Web Token) authentication via `devise-jwt`.

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Create a new account |
| POST | `/api/auth/login` | Login |
| DELETE | `/api/auth/logout` | Logout |
| POST | `/api/auth/refresh` | Refresh access token |

### Usage Example

```bash
# Signup
curl -X POST -H "Content-Type: application/json" \
  -d '{"user": {"email":"user@example.com", "username":"johndoe", "firstname":"John", "lastname":"Doe", "password":"SecurePass123!", "password_confirmation":"SecurePass123!", "career_ids": [1]}}' \
  https://teki-api.fly.dev/api/auth/signup

# Login
curl -X POST -H "Content-Type: application/json" \
  -d '{"user": {"email":"user@example.com", "password":"SecurePass123!"}}' \
  https://teki-api.fly.dev/api/auth/login
```

## 📡 API Endpoints

### Users

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users/:slug` | Get user profile |
| GET | `/api/users` | List all users |
| GET | `/api/users/:slug/posts` | Get user's posts |
| GET | `/api/users/:slug/skills` | Get user's skills |
| GET | `/api/:user_slug/connections` | Get user connections |
| GET | `/api/current_user_skills` | Get current user's skills |

### Posts

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/posts` | Create a post |
| GET | `/api/posts` | Get feed |
| GET | `/api/posts/:id` | Get single post |
| PUT | `/api/posts/:id/like` | Like/unlike a post |

### Relationships

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/relationships` | Follow a user |
| DELETE | `/api/relationships/:id` | Unfollow a user |

### Careers

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/careers` | List all careers |
| GET | `/api/careers/index` | Get careers index |

### Skills

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/skills` | List skills |
| POST | `/api/skills` | Create a skill |

### Comments

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/comments` | List comments |
| POST | `/api/comments` | Create a comment |

## 🔧 Configuration

### Environment Variables

Copy `.env.backup` to `.env` and configure:

```bash
DB_USER=your_db_user
DB_PASS=your_db_password
DB_HOST=localhost
DB_PORT=5432
DB_DEV=teki_development
DB_TEST=teki_test
DB_PROD=teki_production
```

## 🛠 Tech Stack

- **Framework**: Rails 8.0.1 (API mode)
- **Ruby**: 3.4.8
- **Database**: PostgreSQL (Neon)
- **Authentication**: Devise + devise-jwt
- **API Docs**: RSwag (Swagger/OpenAPI)
- **Deployment**: Fly.io, Kamal
- **File Uploads**: Active Storage
- **Image Processing**: Mini Magick

## 📝 License

[Add your license here]
