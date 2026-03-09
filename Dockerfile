# syntax = docker/dockerfile:1

# Stage 1: Build environment
ARG RUBY_VERSION=3.4.8
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
    npm \
    libyaml-dev && \
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

# Copy gems from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy application code from builder
COPY --from=builder /app /app

# Set environment variables
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test" \
    RAILS_ENV=production

# Create non-root user
RUN useradd -m app && \
    chown -R app:app /app

USER app

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/api || exit 1

# Default command
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
