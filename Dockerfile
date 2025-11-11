# syntax = docker/dockerfile:1

# Stage 1: Build environment
ARG RUBY_VERSION=3.4.7
FROM ruby:$RUBY_VERSION-slim as builder

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    pkg-config \
    nodejs \
    npm && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_WITHOUT="development test" \
    RAILS_ENV=production

COPY Gemfile Gemfile.lock ./
RUN bundle install --frozen

# Copy application code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Stage 2: Production image
FROM ruby:$RUBY_VERSION-slim

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq5 \
    postgresql-client \
    curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Create non-root user
RUN useradd -m app && \
    chown -R app:app /app

# Set proper permissions
RUN chmod +x bin/docker-entrypoint

USER app

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT:-3450}/api || exit 1

# Entrypoint
ENTRYPOINT ["bin/docker-entrypoint"]

# Default command
CMD ["sh", "-c", "bin/rails server -b 0.0.0.0 -p ${PORT:-3450}"]
