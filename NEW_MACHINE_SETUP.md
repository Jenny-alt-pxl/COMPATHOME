# 📋 CompatHome - New Machine Setup Guide

## **Prerequisites to Install First**

Before cloning the project, install these on the new machine:

### **1. Required Software**

| Software | Purpose | Installation |
|----------|---------|--------------|
| **Git** | Clone repository | [Download Git](https://git-scm.com/downloads) |
| **Docker Desktop** | Run backend containers | [Download Docker](https://www.docker.com/products/docker-desktop/) |
| **Python 3.11+** | Run frontend server | [Download Python](https://www.python.org/downloads/) |
| **VS Code** | Code editor | [Download VS Code](https://code.visualstudio.com/) |

### **2. Verify Installations**

Open VS Code terminal and verify:

```bash
# Check Git
git --version
# Should show: git version 2.x.x

# Check Docker
docker --version
# Should show: Docker version 24.x.x

# Check Python
python3 --version
# Should show: Python 3.11.x or higher

# Check Docker Compose
docker compose version
# Should show: Docker Compose version v2.x.x
```

---

## **Step-by-Step Setup Instructions**

### **Step 1: Clone the Repository**

Open VS Code terminal and run:

```bash
# Navigate to where you want the project
cd ~/Documents  # or any directory you prefer

# Clone the repository
git clone https://github.com/zaramillion/CompatHome.git

# Navigate into the project
cd CompatHome
```

### **Step 2: Open Project in VS Code**

```bash
# Open the project in VS Code
code .
```

Or use: **File → Open Folder** → Select `CompatHome` folder

---

### **Step 3: Set Up Backend**

#### **3.1 Create Environment File**

In VS Code terminal:

```bash
# Navigate to backend directory
cd backend

# Copy the example environment file
cp .env.example .env
```

The `.env` file is already configured with default values. You can leave it as is for development.

#### **3.2 Start Backend with Docker**

```bash
# Make sure you're in the backend directory
cd backend

# Start Docker containers (database + backend API)
docker compose up -d
```

**Wait 10-15 seconds** for containers to start.

#### **3.3 Verify Backend is Running**

```bash
# Check container status
docker compose ps

# Test the API
curl http://localhost:8000/
```

You should see:
```json
{"message": "CompatHome API is running", "status": "success"}
```

#### **3.4 View Backend Logs (Optional)**

```bash
# View logs to ensure everything is working
docker compose logs -f web

# Press Ctrl+C to stop viewing logs
```

---

### **Step 4: Set Up Frontend**

Open a **NEW terminal** in VS Code (keep backend terminal running):

```bash
# Navigate to frontend directory
cd frontend

# Start the frontend server
python3 -m http.server 3000
```

You should see:
```
Serving HTTP on :: port 3000 (http://[::]:3000/) ...
```

---

### **Step 5: Open the Application**

Open your web browser and go to:

```
http://localhost:3000
```

You should see the CompatHome homepage! 🎉

---

## **Complete VS Code Terminal Commands Reference**

### **Starting the Application**

**Terminal 1 (Backend):**
```bash
cd backend
docker compose up -d
```

**Terminal 2 (Frontend):**
```bash
cd frontend
python3 -m http.server 3000
```

### **Stopping the Application**

**Stop Frontend:**
- Press `Ctrl+C` in the frontend terminal

**Stop Backend:**
```bash
cd backend
docker compose down
```

### **Restarting the Application**

**Restart Backend:**
```bash
cd backend
docker compose restart
```

**Restart Frontend:**
- Press `Ctrl+C` in terminal
- Run `python3 -m http.server 3000` again

### **Viewing Logs**

**Backend Logs:**
```bash
cd backend
docker compose logs -f web
```

**Database Logs:**
```bash
cd backend
docker compose logs -f db
```

**All Logs:**
```bash
cd backend
docker compose logs -f
```

### **Checking Status**

**Backend Status:**
```bash
cd backend
docker compose ps
```

**Test Backend API:**
```bash
curl http://localhost:8000/
curl http://localhost:8000/api/listings
```

**Test Frontend:**
```bash
curl http://localhost:3000/
```

---

## **Database Management**

### **Access Database Shell**

```bash
cd backend
docker compose exec db psql -U compathome_user -d compathome_db
```

**Common SQL Commands:**
```sql
-- List all tables
\dt

-- Count users
SELECT COUNT(*) FROM users;

-- Count listings
SELECT COUNT(*) FROM property_listings;

-- View all users
SELECT id, email, username, full_name FROM users;

-- Exit database shell
\q
```

### **Reset Database (Clean Start)**

```bash
cd backend
docker compose down -v
docker compose up -d
```

---

## **Troubleshooting**

### **Problem: Port Already in Use**

**Backend (Port 8000):**
```bash
# Find process using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or use different port in docker-compose.yml
# Change: "8000:5000" to "8001:5000"
```

**Frontend (Port 3000):**
```bash
# Use a different port
python3 -m http.server 3001

# Then access: http://localhost:3001
```

### **Problem: Docker Not Running**

```bash
# Start Docker Desktop application
# Wait for Docker to fully start
# Then run:
docker compose up -d
```

### **Problem: Backend Not Responding**

```bash
cd backend

# Check logs for errors
docker compose logs web

# Restart containers
docker compose restart

# Or rebuild completely
docker compose down
docker compose up -d --build
```

### **Problem: Database Connection Error**

```bash
cd backend

# Check database is healthy
docker compose exec db pg_isready -U compathome_user -d compathome_db

# If not ready, restart
docker compose restart db

# Wait 10 seconds, then restart web
docker compose restart web
```

### **Problem: Frontend Files Not Loading**

```bash
# Make sure you're in the frontend directory
cd frontend
pwd  # Should show: .../CompatHome/frontend

# Start server
python3 -m http.server 3000

# Clear browser cache (Cmd+Shift+R or Ctrl+Shift+R)
```

---

## **Testing the Application**

### **1. Create a Test Account**

1. Go to `http://localhost:3000`
2. Click **"Sign Up"**
3. Fill in:
   - Email: `test@example.com`
   - Username: `testuser`
   - Password: `SecurePass123!`
   - Full Name: `Test User`
   - Phone: `+237670000000`
4. Click **"Sign Up"**

### **2. Browse Listings**

- Scroll down to see featured listings
- Use filters (city, property type, price range)
- Click on a listing to view details

### **3. Test API Directly**

```bash
# Sign up via API
curl -X POST http://localhost:8000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "api@test.com",
    "username": "apiuser",
    "password": "SecurePass123!",
    "full_name": "API Test User",
    "phone_number": "+237670000001"
  }'

# Get listings
curl http://localhost:8000/api/listings
```

---

## **Running Tests (Optional)**

### **Backend Tests**

```bash
cd backend

# Install test dependencies (if not using Docker)
pip install pytest pytest-cov pytest-flask

# Run all tests
docker compose exec web pytest tests/ -v

# Run specific test file
docker compose exec web pytest tests/test_auth_service.py -v
```

### **Integration Tests**

```bash
# From project root
bash test_frontend_backend_integration.sh
```

---

## **Project Structure Overview**

```
CompatHome/
├── backend/                    # Flask Backend
│   ├── services/              # Microservices
│   │   ├── auth/             # Authentication
│   │   ├── listing/          # Property listings
│   │   ├── messaging/        # Messages
│   │   ├── payment/          # Payments
│   │   ├── rating/           # Ratings
│   │   ├── recommendation/   # AI recommendations
│   │   └── tour/             # Tour requests
│   ├── shared/               # Shared utilities
│   ├── tests/                # Test suite
│   ├── app.py                # Main Flask app
│   ├── config.py             # Configuration
│   ├── requirements.txt      # Python dependencies
│   ├── Dockerfile            # Docker config
│   └── docker-compose.yml    # Docker Compose config
│
├── frontend/                  # Vanilla JS Frontend
│   ├── pages/                # HTML pages
│   ├── js/                   # JavaScript modules
│   ├── css/                  # Stylesheets
│   ├── assets/               # Images, etc.
│   └── index.html            # Homepage
│
└── Documentation files
```

---

## **Access URLs**

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:3000 | Main website |
| **Backend API** | http://localhost:8000 | REST API |
| **Database** | localhost:5433 | PostgreSQL (external access) |
| **API Docs** | See `backend/API_DOCUMENTATION.md` | API reference |

---

## **Environment Configuration**

The `.env` file in `backend/` contains:

```env
# Database
DATABASE_URL=postgresql://compathome_user:compathome_pass@db:5432/compathome_db

# Flask
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=your-secret-key-change-in-production

# JWT
JWT_SECRET_KEY=your-jwt-secret-key-change-in-production
JWT_ACCESS_TOKEN_EXPIRES=3600

# Uploads
UPLOAD_FOLDER=/app/uploads
MAX_CONTENT_LENGTH=16777216
ALLOWED_EXTENSIONS=jpg,jpeg,png,gif

# Currency
DEFAULT_CURRENCY=XAF
```

**For production**, change the secret keys to secure random values.

---

## **Quick Start Summary**

```bash
# 1. Clone repository
git clone https://github.com/zaramillion/CompatHome.git
cd CompatHome

# 2. Start backend (Terminal 1)
cd backend
docker compose up -d

# 3. Start frontend (Terminal 2)
cd frontend
python3 -m http.server 3000

# 4. Open browser
# Go to: http://localhost:3000
```

---

## **Stopping Everything**

```bash
# Stop frontend (in frontend terminal)
Ctrl+C

# Stop backend
cd backend
docker compose down
```

---

## **Additional Resources**

- **Quick Start Guide**: `QUICK_START.md`
- **API Documentation**: `backend/API_DOCUMENTATION.md`
- **Docker Setup**: `DOCKER_SETUP.md`
- **Architecture**: `ARCHITECTURE.md`
- **Complete Summary**: `COMPLETE_PROJECT_SUMMARY.md`

---

## **Support**

If you encounter any issues:

1. Check the troubleshooting section above
2. Review the logs: `docker compose logs -f`
3. Ensure Docker Desktop is running
4. Verify all prerequisites are installed correctly

---

**That's it! You're ready to run CompatHome on any new machine! 🚀**

