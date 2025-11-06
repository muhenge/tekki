# 🐳 Docker Configuration for Tekki API

## 📋 Overview

This document describes the Docker configuration optimized for Kamal deployment of the Tekki API.

## 🏗️ Dockerfile Structure

### **Multi-Stage Build**

The Dockerfile uses a multi-stage build approach for optimal image size and security:

1. **Builder Stage**: Compiles gems and precompiles assets
2. **Production Stage**: Creates minimal runtime image

### **Key Features**

- ✅ **Ruby 3.4.1** - Latest stable Ruby version
- ✅ **Multi-stage build** - Optimized image size
- ✅ **Non-root user** - Enhanced security
- ✅ **Health checks** - Container health monitoring
- ✅ **Asset precompilation** - Production-ready assets
- ✅ **Database connectivity** - PostgreSQL support

## 🔧 Build Process

### **Stage 1: Builder**
```dockerfile
FROM ruby:3.4.1-slim as builder
```

**Installs:**
- Build dependencies (build-essential, curl, git, libpq-dev, pkg-config)
- Node.js and npm (for asset compilation)
- Ruby gems (production only)
- Precompiles Rails assets

### **Stage 2: Production**
```dockerfile
FROM ruby:3.4.1-slim
```

**Installs:**
- Runtime dependencies (libpq5, postgresql-client, curl)
- Copies compiled artifacts from builder stage
- Creates non-root user (`app`)
- Sets up health checks

## 🚀 Entrypoint Script

### **Enhanced `bin/docker-entrypoint`**

The entrypoint script handles:

1. **Database Connection Check**
   - Waits for PostgreSQL to be ready
   - Uses `pg_isready` for connection validation

2. **Database Migrations**
   - Runs migrations when `RUN_MIGRATIONS=true`
   - Safe for production deployments

3. **Directory Setup**
   - Creates necessary directories (`tmp/pids`, `log`)
   - Sets proper permissions

4. **Process Management**
   - Removes stale PID files
   - Starts Rails server

## 📦 Build Optimization

### **`.dockerignore` File**

Excludes unnecessary files from build context:

- Git files (`.git`, `.gitignore`)
- Documentation (`*.md`)
- Development files (`.env`, `spec/`, `test/`)
- IDE files (`.vscode/`, `.idea/`)
- OS files (`.DS_Store`, `Thumbs.db`)
- Kamal deployment files (`.kamal/`)

### **Layer Optimization**

- **Gemfile copying**: Separate layer for dependency caching
- **Asset precompilation**: Done in builder stage
- **Minimal runtime**: Only production dependencies

## 🔍 Health Checks

### **Built-in Health Check**

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/api || exit 1
```

**Configuration:**
- **Interval**: 30 seconds between checks
- **Timeout**: 3 seconds per check
- **Start period**: 5 seconds before first check
- **Retries**: 3 attempts before marking unhealthy

## 🛡️ Security Features

### **Non-Root User**
```dockerfile
RUN useradd -m app && chown -R app:app /app
USER app
```

### **Minimal Dependencies**
- Only production gems (`BUNDLE_WITHOUT="development test"`)
- Minimal runtime packages
- No unnecessary build tools in production image

### **Proper Permissions**
- Application files owned by `app` user
- Executable permissions set correctly

## 🌐 Environment Variables

### **Required Variables**

```bash
# Database Configuration
DATABASE_HOST=your_db_host
DATABASE_PORT=5432
DATABASE_USERNAME=your_db_user
DATABASE_NAME=your_db_name
DATABASE_PASSWORD=your_db_password

# Rails Configuration
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true

# Optional
RUN_MIGRATIONS=true
SKIP_DATABASE_CHECK=false
```

## 🚀 Building and Running

### **Local Build**
```bash
# Build the image
docker build -t tekki-api .

# Run locally
docker run -p 3000:3000 \
  -e DATABASE_HOST=localhost \
  -e DATABASE_USERNAME=postgres \
  -e DATABASE_PASSWORD=password \
  -e DATABASE_NAME=tekki_production \
  tekki-api
```

### **Kamal Deployment**
```bash
# Build and deploy
kamal build
kamal deploy
```

## 📊 Image Size Optimization

### **Before Optimization**
- Single-stage build: ~800MB
- All dependencies included

### **After Optimization**
- Multi-stage build: ~300MB
- Only production dependencies
- Precompiled assets included

## 🔧 Customization

### **Adding Dependencies**

**Build dependencies** (builder stage):
```dockerfile
RUN apt-get install --no-install-recommends -y \
    your-build-dependency
```

**Runtime dependencies** (production stage):
```dockerfile
RUN apt-get install --no-install-recommends -y \
    your-runtime-dependency
```

### **Environment-Specific Builds**

```bash
# Development build
docker build --target builder -t tekki-api:dev .

# Production build
docker build -t tekki-api:prod .
```

## 🐛 Troubleshooting

### **Common Issues**

1. **Build Failures**
   - Check `.dockerignore` for excluded files
   - Verify Gemfile.lock is present
   - Ensure all dependencies are available

2. **Runtime Errors**
   - Check environment variables
   - Verify database connectivity
   - Check container logs: `docker logs container_name`

3. **Asset Issues**
   - Ensure assets are precompiled
   - Check `RAILS_SERVE_STATIC_FILES=true`
   - Verify asset paths

### **Debug Commands**

```bash
# Inspect image layers
docker history tekki-api

# Run interactive shell
docker run -it tekki-api bash

# Check container logs
docker logs tekki-api-container

# Inspect running container
docker exec -it tekki-api-container bash
```

## 📈 Performance Tips

1. **Use BuildKit**: `DOCKER_BUILDKIT=1 docker build`
2. **Multi-platform builds**: `docker buildx build --platform linux/amd64,linux/arm64`
3. **Layer caching**: Order Dockerfile commands by change frequency
4. **Asset optimization**: Use CDN for static assets in production

---

**Your Docker configuration is now optimized for Kamal deployment!** 🚀



