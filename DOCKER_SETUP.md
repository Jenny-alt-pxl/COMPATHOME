# 🐳 CompatHome - Docker Setup Guide

## ✅ Current Status

Your Docker setup is **fully operational**!

### Running Services

| Service | Container Name | Status | Port | Health |
|---------|---------------|--------|------|--------|
| Backend API | `compathome_web` | ✅ Running | 8000 → 5000 | Healthy |
| PostgreSQL Database | `compathome_db` | ✅ Running | 5433 → 5432 | Healthy |

### Database Statistics

- **Users**: 3
- **Listings**: 3
- **Messages**: 0
- **Tables**: 6 (users, property_listings, messages, payments, ratings, tour_requests)

---

## 🚀 Quick Start

### Start Services
```bash
./docker-helper.sh start
```

### Stop Services
```bash
./docker-helper.sh stop
```

### View Status
```bash
./docker-helper.sh status
```

### Verify Everything is Working
```bash
./docker-helper.sh verify
```

---

## 📋 Available Commands

The `docker-helper.sh` script provides easy access to all Docker operations:

```bash
./docker-helper.sh [command]
```

### Commands

| Command | Description |
|---------|-------------|
| `start` | Start all services |
| `stop` | Stop all services |
| `restart` | Restart all services |
| `status` | Show container status |
| `logs` | View all logs (follow mode) |
| `logs-web` | View web service logs only |
| `logs-db` | View database logs only |
| `build` | Rebuild containers |
| `clean` | Stop and remove all containers and volumes |
| `shell` | Open shell in web container |
| `db-shell` | Open PostgreSQL shell |
| `test` | Run tests in container |
| `verify` | Verify setup is working |

---

## 🔧 Manual Docker Commands

If you prefer to use Docker commands directly, add Docker to your PATH first:

```bash
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
```

### Common Operations

#### Start Services
```bash
cd backend
docker compose up -d
```

#### Stop Services
```bash
cd backend
docker compose down
```

#### View Logs
```bash
cd backend
docker compose logs -f
```

#### Restart Services
```bash
cd backend
docker compose restart
```

#### Check Status
```bash
cd backend
docker compose ps
```

#### Rebuild Containers
```bash
cd backend
docker compose build
docker compose up -d
```

---

## 🗄️ Database Access

### Using Docker Helper
```bash
./docker-helper.sh db-shell
```

### Manual Access
```bash
cd backend
docker compose exec db psql -U compathome_user -d compathome_db
```

### Common SQL Queries

```sql
-- List all tables
\dt

-- Count users
SELECT COUNT(*) FROM users;

-- Count listings
SELECT COUNT(*) FROM property_listings;

-- View recent listings
SELECT id, title, city, price FROM property_listings ORDER BY created_at DESC LIMIT 5;

-- Exit
\q
```

---

## 🧪 Testing

### Run All Tests
```bash
./docker-helper.sh test
```

### Manual Test Execution
```bash
cd backend
docker compose exec web pytest tests/ -v
```

### Test with Coverage
```bash
cd backend
docker compose exec web pytest tests/ -v --cov=services --cov=shared --cov-report=term
```

---

## 🌐 API Endpoints

### Base URL
```
http://localhost:8000
```

### Test Endpoints

```bash
# Health check
curl http://localhost:8000/

# Get all listings
curl http://localhost:8000/api/listings

# Get specific listing
curl http://localhost:8000/api/listings/1
```

---

## 🔍 Troubleshooting

### Containers Not Starting

1. Check if Docker Desktop is running
2. Verify Docker daemon:
   ```bash
   export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
   docker info
   ```

### Database Connection Issues

1. Check database health:
   ```bash
   cd backend
   docker compose exec db pg_isready -U compathome_user -d compathome_db
   ```

2. View database logs:
   ```bash
   ./docker-helper.sh logs-db
   ```

### API Not Responding

1. Check web service logs:
   ```bash
   ./docker-helper.sh logs-web
   ```

2. Restart services:
   ```bash
   ./docker-helper.sh restart
   ```

### Fresh Start

If you need to start from scratch:

```bash
./docker-helper.sh clean
./docker-helper.sh start
```

---

## 📊 Monitoring

### View Real-time Logs
```bash
./docker-helper.sh logs
```

### Check Container Resources
```bash
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
docker stats compathome_web compathome_db
```

### Inspect Container
```bash
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
docker inspect compathome_web
```

---

## 🎯 Next Steps

1. ✅ Docker is running and connected
2. ✅ All services are healthy
3. ✅ Database is populated with test data
4. ✅ API is responding correctly

**You're all set!** Your CompatHome application is ready to use.

### Access the Application

- **Backend API**: http://localhost:8000
- **Database**: localhost:5433
- **Frontend**: Start with `cd frontend && python3 -m http.server 3000`

---

## 📝 Notes

- Docker Desktop version: 29.1.3
- Docker Compose version: v2.40.3
- PostgreSQL version: 15-alpine
- Python version: 3.11-slim

