# Tekki API

A Rails 8.0 REST API for a professional social networking platform.

## 🌐 Live Deployment

**Production API**: https://teki-api.fly.dev

**Swagger Documentation**: https://teki-api.fly.dev/api-docs

## 🚀 Quick Start

### Prerequisites
- Ruby 3.4.8
- PostgreSQL
- Node.js & npm

### Docker Deployment

```bash
# Build and run with Docker
docker build -t teki .
docker run -p 3000:3000 --env-file .env teki
```

## 🛠 Tech Stack

- **Framework**: Rails 8.0.1 (API mode)
- **Ruby**: 3.4.8
- **Database**: PostgreSQL (Neon)
- **Authentication**: Devise + devise-jwt
- **API Docs**: RSwag (Swagger/OpenAPI)
- **Deployment**: Fly.io
- **File Uploads**: Active Storage
- **Image Processing**: Mini Magick
