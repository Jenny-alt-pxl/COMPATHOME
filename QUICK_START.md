# 🚀 CompatHome - Quick Start Guide

## Prerequisites

- Docker and Docker Compose installed
- Python 3.11+ installed
- Web browser (Chrome, Firefox, Safari, or Edge)

---

## Step 1: Start the Backend

Open a terminal and run:

```bash
cd backend
docker compose up -d
```

**Wait for the containers to start** (about 10-15 seconds).

Verify backend is running:

```bash
curl http://localhost:8000/
```

You should see: `{"message": "CompatHome API is running", "status": "success"}`

---

## Step 2: Start the Frontend

Open a **new terminal** and run:

```bash
cd frontend
python3 -m http.server 3000
```

You should see: `Serving HTTP on :: port 3000 (http://[::]:3000/) ...`

---

## Step 3: Open the Application

Open your web browser and go to:

```
http://localhost:3000
```

---

## Step 4: Test the Application

### Create an Account

1. Click **"Sign Up"** button
2. Fill in the form:
   - Username: `testuser`
   - Email: `test@example.com`
   - Password: `SecurePass123!`
   - Full Name: `Test User`
   - Phone: `+237670000000`
3. Click **"Sign Up"**
4. You should be logged in automatically

### Browse Listings

1. Scroll down to see featured listings
2. Try the filters:
   - Select a city (e.g., Yaoundé)
   - Select property type (e.g., Room)
   - Set price range
   - Click **"Apply Filters"**

### View Listing Details

1. Click on any listing card
2. View photos, description, amenities
3. See owner information

### Create a Listing (Requires Payment)

1. Make sure you're logged in
2. Initiate payment:
   ```bash
   # In a terminal, run:
   curl -X POST http://localhost:8000/api/payment/initiate \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"phone_number": "+237670000000", "amount": 5000}'
   ```
3. Note the `confirmation_code` from the response
4. Confirm payment:
   ```bash
   curl -X POST http://localhost:8000/api/payment/confirm/TRANSACTION_REF \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"confirmation_code": "123456"}'
   ```
5. Now you can create listings!

---

## Step 5: Run Tests (Optional)

### Backend Tests

```bash
cd backend
source venv/bin/activate
pytest tests/ -v
```

### Integration Tests

```bash
bash test_frontend_backend_integration.sh
```

---

## Troubleshooting

### Backend not starting?

```bash
cd backend
docker compose down -v
docker compose up -d
```

### Frontend not loading?

Make sure you're in the `frontend` directory:

```bash
cd frontend
python3 -m http.server 3000
```

### Port already in use?

Change the frontend port:

```bash
python3 -m http.server 3001
```

Then access: `http://localhost:3001`

### Can't see listings?

Check backend is running:

```bash
curl http://localhost:8000/api/listings
```

---

## Stopping the Application

### Stop Frontend

Press `Ctrl+C` in the terminal running the frontend server.

### Stop Backend

```bash
cd backend
docker compose down
```

---

## Quick Commands Reference

```bash
# Start backend
cd backend && docker compose up -d

# Start frontend
cd frontend && python3 -m http.server 3000

# Stop backend
cd backend && docker compose down

# View backend logs
cd backend && docker compose logs -f web

# Restart backend
cd backend && docker compose restart

# Run tests
cd backend && pytest tests/ -v

# Check backend status
cd backend && docker compose ps
```

---

## Default Credentials for Testing

You can create test accounts with these details:

**User 1**:
- Email: `john@example.com`
- Password: `SecurePass123!`
- Phone: `+237670000001`

**User 2**:
- Email: `jane@example.com`
- Password: `SecurePass123!`
- Phone: `+237670000002`

---

## Access URLs

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Database**: localhost:5433 (PostgreSQL)

---

## Need Help?

1. Check `COMPLETE_PROJECT_SUMMARY.md` for full documentation
2. Check `backend/README.md` for backend details
3. Check `frontend/README.md` for frontend details
4. Run integration tests: `bash test_frontend_backend_integration.sh`

---

**Enjoy using CompatHome! 🏠**

