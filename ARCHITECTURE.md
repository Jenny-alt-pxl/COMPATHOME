# CompatHome - System Architecture

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER BROWSER                             │
│                     http://localhost:3000                        │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ HTTP/HTTPS
                         │
┌────────────────────────▼────────────────────────────────────────┐
│                      FRONTEND LAYER                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  HTML/CSS/JavaScript (Vanilla)                           │  │
│  │  - index.html (Landing page)                             │  │
│  │  - style.css (Responsive design)                         │  │
│  │  - config.js (Configuration)                             │  │
│  │  - api.js (API service layer)                            │  │
│  │  - auth.js (Authentication manager)                      │  │
│  │  - listings.js (Listings manager)                        │  │
│  │  - main.js (Application logic)                           │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ REST API (JSON)
                         │ JWT Authentication
                         │
┌────────────────────────▼────────────────────────────────────────┐
│                      BACKEND LAYER                               │
│                   http://localhost:8000                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Flask Application (Python 3.11)                         │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  API Gateway (app.py)                              │  │  │
│  │  │  - CORS enabled                                    │  │  │
│  │  │  - JWT middleware                                  │  │  │
│  │  │  - File upload handling                            │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                            │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Microservices                                     │  │  │
│  │  │  ┌──────────────┐  ┌──────────────┐               │  │  │
│  │  │  │ Auth Service │  │ Payment Svc  │               │  │  │
│  │  │  │ - Signup     │  │ - Initiate   │               │  │  │
│  │  │  │ - Login      │  │ - Confirm    │               │  │  │
│  │  │  │ - Profile    │  │ - History    │               │  │  │
│  │  │  └──────────────┘  └──────────────┘               │  │  │
│  │  │                                                     │  │  │
│  │  │  ┌──────────────┐  ┌──────────────┐               │  │  │
│  │  │  │Listing Svc   │  │ Message Svc  │               │  │  │
│  │  │  │ - CRUD       │  │ - Send       │               │  │  │
│  │  │  │ - Search     │  │ - Threads    │               │  │  │
│  │  │  │ - Photos     │  │ - Read       │               │  │  │
│  │  │  └──────────────┘  └──────────────┘               │  │  │
│  │  │                                                     │  │  │
│  │  │  ┌──────────────┐  ┌──────────────┐               │  │  │
│  │  │  │  Tour Svc    │  │ Rating Svc   │               │  │  │
│  │  │  │ - Request    │  │ - Create     │               │  │  │
│  │  │  │ - Manage     │  │ - Average    │               │  │  │
│  │  │  └──────────────┘  └──────────────┘               │  │  │
│  │  │                                                     │  │  │
│  │  │  ┌──────────────┐                                  │  │  │
│  │  │  │Recommend Svc │                                  │  │  │
│  │  │  │ - AI Match   │                                  │  │  │
│  │  │  │ - Cosine Sim │                                  │  │  │
│  │  │  └──────────────┘                                  │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                                                            │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  ORM Layer (SQLAlchemy 2.0.23)                     │  │  │
│  │  │  - User model                                      │  │  │
│  │  │  - Payment model                                   │  │  │
│  │  │  - Listing model                                   │  │  │
│  │  │  - Message model                                   │  │  │
│  │  │  - Tour model                                      │  │  │
│  │  │  - Rating model                                    │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ SQL Queries
                         │
┌────────────────────────▼────────────────────────────────────────┐
│                     DATABASE LAYER                               │
│                   localhost:5433 (host)                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  PostgreSQL 15 (Alpine)                                  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  Tables:                                           │  │  │
│  │  │  - users                                           │  │  │
│  │  │  - payments                                        │  │  │
│  │  │  - listings                                        │  │  │
│  │  │  - messages                                        │  │  │
│  │  │  - tour_requests                                   │  │  │
│  │  │  - ratings                                         │  │  │
│  │  │  - user_preferences                                │  │  │
│  │  │  - roommate_matches                                │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow

### User Registration Flow

```
Browser → Frontend (auth.js)
   ↓
   POST /api/auth/signup
   ↓
Backend (auth/routes.py)
   ↓
   Validate data
   ↓
   Hash password (bcrypt)
   ↓
   Create user in DB
   ↓
   Generate JWT token
   ↓
   Return token + user data
   ↓
Frontend stores token in localStorage
   ↓
UI updates (show user menu)
```

### Listing Creation Flow

```
Browser → Frontend (listings.js)
   ↓
   Check if user has paid
   ↓
   POST /api/listings
   ↓
Backend (listing/routes.py)
   ↓
   Verify JWT token
   ↓
   Check payment status
   ↓
   Create listing in DB
   ↓
   Return listing data
   ↓
Frontend displays success
```

### File Upload Flow

```
Browser → File input
   ↓
   FormData with file
   ↓
   POST /api/auth/upload-photo
   ↓
Backend (auth/routes.py)
   ↓
   Validate file type
   ↓
   Generate unique filename (UUID)
   ↓
   Save to /app/uploads
   ↓
   Update user.profile_photo in DB
   ↓
   Return filename + URL
   ↓
Frontend updates avatar image
```

## 🐳 Docker Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Docker Compose                        │
│                                                          │
│  ┌────────────────────┐      ┌────────────────────┐    │
│  │  Web Container     │      │  DB Container      │    │
│  │  (compathome_web)  │      │  (compathome_db)   │    │
│  │                    │      │                    │    │
│  │  Image: backend-web│      │  Image: postgres   │    │
│  │  Port: 8000:5000   │◄────►│  Port: 5433:5432   │    │
│  │                    │      │                    │    │
│  │  Volumes:          │      │  Volumes:          │    │
│  │  - uploads_data    │      │  - postgres_data   │    │
│  │                    │      │                    │    │
│  │  Health check:     │      │  Health check:     │    │
│  │  curl localhost    │      │  pg_isready        │    │
│  └────────────────────┘      └────────────────────┘    │
│                                                          │
│  Network: compathome_network                            │
└─────────────────────────────────────────────────────────┘
```

## 📊 Technology Stack

### Frontend
- **HTML5** - Semantic markup
- **CSS3** - Grid, Flexbox, Animations
- **JavaScript ES6+** - Async/await, Fetch API, Classes
- **Font Awesome 6.4.0** - Icons

### Backend
- **Python 3.11** - Programming language
- **Flask 3.0.0** - Web framework
- **SQLAlchemy 2.0.23** - ORM
- **Flask-JWT-Extended** - JWT authentication
- **Flask-Bcrypt** - Password hashing
- **Flask-CORS** - CORS handling
- **scikit-learn** - AI recommendations
- **Werkzeug** - File uploads

### Database
- **PostgreSQL 15** - Relational database
- **Alpine Linux** - Lightweight container

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration

## 🔐 Security Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Security Layers                       │
│                                                          │
│  1. Frontend Validation                                 │
│     - Email format                                      │
│     - Phone format (+237XXXXXXXXX)                      │
│     - Password strength (min 8 chars)                   │
│     - File type validation                              │
│                                                          │
│  2. JWT Authentication                                  │
│     - Token generation on login                         │
│     - Token verification on protected routes            │
│     - Token stored in localStorage                      │
│                                                          │
│  3. Backend Validation                                  │
│     - Input sanitization                                │
│     - SQL injection protection (ORM)                    │
│     - File type validation                              │
│     - File size limits (16MB)                           │
│                                                          │
│  4. Password Security                                   │
│     - Bcrypt hashing (cost factor 12)                   │
│     - Never stored in plain text                        │
│                                                          │
│  5. Database Security                                   │
│     - Credentials in environment variables              │
│     - Connection pooling                                │
│     - Prepared statements (SQLAlchemy)                  │
└─────────────────────────────────────────────────────────┘
```

## 📈 Scalability Considerations

### Current Architecture
- Single web server container
- Single database container
- File storage on local volume

### Future Enhancements
- Load balancer (Nginx)
- Multiple web server instances
- Database replication (master-slave)
- Redis for caching
- S3/Cloud storage for files
- CDN for static assets
- Message queue (RabbitMQ/Celery)
- Microservices in separate containers

---

**Built with ❤️ for Cameroon**

