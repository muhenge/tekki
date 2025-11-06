# 🚀 Kamal Deployment Guide for Tekki API

## 📋 Pre-Deployment Checklist

### ✅ **1. Configuration Files Updated**
- ✅ `config/deploy.yml` - Updated with your app details
- ✅ `.kamal/secrets` - Configured for environment variables
- ✅ `config/master.key` - Generated for Rails credentials
- ✅ `Dockerfile` - Ready for production build

### ✅ **2. Required Environment Variables**

Set these environment variables before deployment:

```bash
# Docker Registry (Docker Hub)
export KAMAL_REGISTRY_PASSWORD="your_dockerhub_token"

# Rails Master Key (already generated)
export RAILS_MASTER_KEY="e729899073df7373a5dec147b7eaebb5"

# Database Password
export DATABASE_PASSWORD="npg_5HNaXkymPQ0D"

# Database Configuration (from your .env)
export DB_HOST="ep-polished-bird-a57xxlgo-pooler.us-east-2.aws.neon.tech"
export DB_PORT="5432"
export DB_USER="konnecta_db_owner"
export DB_PROD="konnecta_db_production"
```

### ✅ **3. Domain Configuration**
Update `config/deploy.yml` line 22:
```yaml
host: tekki.yourdomain.com  # Replace with your actual domain
```

## 🚀 **Deployment Commands**

### **Step 1: Setup Server**
```bash
kamal setup
```
This will:
- Install Docker on your server
- Setup SSL certificates
- Configure the proxy
- Pull and start your application

### **Step 2: Deploy Application**
```bash
kamal deploy
```
This will:
- Build Docker image
- Push to registry
- Deploy to server
- Run database migrations
- Start the application

### **Step 3: Check Status**
```bash
kamal app logs
kamal app details
```

## 🔧 **Useful Kamal Commands**

### **Application Management**
```bash
kamal app logs                    # View application logs
kamal app details                 # Show app status
kamal app exec "rails console"    # Access Rails console
kamal app exec "bash"             # Access container shell
```

### **Deployment Management**
```bash
kamal deploy                      # Deploy new version
kamal rollback                    # Rollback to previous version
kamal redeploy                    # Redeploy current version
```

### **Configuration**
```bash
kamal config                      # Show current configuration
kamal config validate            # Validate configuration
kamal secrets set KEY=value      # Set secrets
```

### **Server Management**
```bash
kamal server bootstrap           # Bootstrap server (run setup)
kamal server details             # Show server info
kamal proxy logs                 # View proxy logs
```

## 🐳 **Docker Registry Setup**

### **Option 1: Docker Hub (Recommended)**
1. Create account at [hub.docker.com](https://hub.docker.com)
2. Create access token in Account Settings > Security
3. Set environment variable:
   ```bash
   export KAMAL_REGISTRY_PASSWORD="your_dockerhub_token"
   ```

### **Option 2: GitHub Container Registry**
Update `config/deploy.yml`:
```yaml
registry:
  server: ghcr.io
  username: ngenzi
  password:
    - KAMAL_REGISTRY_PASSWORD
```

## 🔐 **Security Notes**

### **Secrets Management**
- ✅ Never commit `config/master.key` to git
- ✅ Use environment variables for sensitive data
- ✅ Consider using password managers for production

### **SSL Configuration**
- ✅ Let's Encrypt certificates auto-generated
- ✅ HTTPS redirect enabled
- ✅ Update domain in `config/deploy.yml`

## 📊 **Monitoring & Debugging**

### **Application Health**
```bash
# Check if app is running
kamal app details

# View real-time logs
kamal app logs --follow

# Access Rails console
kamal app exec "rails console"
```

### **Database Access**
```bash
# Run migrations manually
kamal app exec "rails db:migrate"

# Access database console
kamal app exec "rails dbconsole"
```

### **Common Issues**
1. **Build Failures**: Check Dockerfile and dependencies
2. **Database Connection**: Verify environment variables
3. **SSL Issues**: Check domain configuration
4. **Memory Issues**: Monitor server resources

## 🌐 **Post-Deployment**

### **API Endpoints**
- **API Base**: `https://tekki.yourdomain.com/api`
- **Swagger Docs**: `https://tekki.yourdomain.com/api-docs`
- **Health Check**: `https://tekki.yourdomain.com/api`

### **Environment Verification**
```bash
# Test API endpoints
curl https://tekki.yourdomain.com/api/users
curl https://tekki.yourdomain.com/api-docs
```

## 📝 **Next Steps**

1. **Set Environment Variables** (see above)
2. **Update Domain** in `config/deploy.yml`
3. **Run `kamal setup`** to initialize server
4. **Run `kamal deploy`** to deploy application
5. **Test API endpoints** and Swagger documentation

## 🆘 **Troubleshooting**

### **Common Commands**
```bash
# Check configuration
kamal config validate

# View detailed logs
kamal app logs --lines 100

# Restart application
kamal app restart

# Check server resources
kamal server exec "htop"
```

### **Emergency Rollback**
```bash
kamal rollback
```

---

**Ready to deploy?** 🚀
1. Set your environment variables
2. Update your domain
3. Run `kamal setup`
4. Run `kamal deploy`



