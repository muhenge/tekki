#!/bin/bash

# 🚀 Tekki Kamal Deployment Setup Script
# This script helps you set up the required environment variables for Kamal deployment

echo "🚀 Tekki Kamal Deployment Setup"
echo "================================"

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Please create it first."
    exit 1
fi

echo "📋 Setting up environment variables..."

# Source the .env file to get database credentials
source .env

# Set Kamal required environment variables
export KAMAL_REGISTRY_PASSWORD="${KAMAL_REGISTRY_PASSWORD:-your_dockerhub_token}"
export RAILS_MASTER_KEY="e729899073df7373a5dec147b7eaebb5"
export DATABASE_PASSWORD="${DB_PASS}"
export DB_HOST="${DB_HOST}"
export DB_PORT="${DB_PORT}"
export DB_USER="${DB_USER}"
export DB_PROD="${DB_PROD:-konnecta_db_production}"

echo "✅ Environment variables set:"
echo "   - KAMAL_REGISTRY_PASSWORD: ${KAMAL_REGISTRY_PASSWORD:0:10}..."
echo "   - RAILS_MASTER_KEY: ${RAILS_MASTER_KEY:0:10}..."
echo "   - DATABASE_PASSWORD: ${DATABASE_PASSWORD:0:10}..."
echo "   - DB_HOST: $DB_HOST"
echo "   - DB_PORT: $DB_PORT"
echo "   - DB_USER: $DB_USER"
echo "   - DB_PROD: $DB_PROD"

echo ""
echo "🔧 Next steps:"
echo "1. Update your domain in config/deploy.yml (line 22)"
echo "2. Set your Docker Hub token: export KAMAL_REGISTRY_PASSWORD='your_token'"
echo "3. Run: kamal setup"
echo "4. Run: kamal deploy"
echo ""
echo "📚 For detailed instructions, see: KAMAL_DEPLOYMENT_GUIDE.md"



