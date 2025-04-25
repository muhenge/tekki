# syntax = docker/dockerfile:1

# Stage 1: Build environment
ARG RUBY_VERSION=3.4.1
FROM ruby:$RUBY_VERSION-slim as builder

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_WITHOUT="development test"

COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Stage 2: Production image
FROM ruby:$RUBY_VERSION-slim

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq5 \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy built artifacts from builder
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Create non-root user
RUN useradd -m app && \
    chown -R app:app /app
USER app

# Entrypoint
COPY bin/docker-entrypoint /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]

# Default command
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
