#!/bin/bash

# CompatHome Frontend-Backend Integration Test
# This script tests the complete integration between frontend and backend

echo "========================================="
echo "CompatHome Integration Test"
echo "========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0

# Function to test endpoint
test_endpoint() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "Testing $name... "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$response" -eq "$expected_status" ]; then
        echo -e "${GREEN}✓ PASSED${NC} (HTTP $response)"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAILED${NC} (Expected HTTP $expected_status, got $response)"
        ((FAILED++))
    fi
}

# Check if backend is running
echo "Checking backend status..."
if ! curl -s http://localhost:8000/ > /dev/null 2>&1; then
    echo -e "${RED}✗ Backend is not running on http://localhost:8000${NC}"
    echo "Please start the backend with: cd backend && docker compose up -d"
    exit 1
fi
echo -e "${GREEN}✓ Backend is running${NC}"
echo ""

# Check if frontend is running
echo "Checking frontend status..."
if ! curl -s http://localhost:3000/ > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠ Frontend is not running on http://localhost:3000${NC}"
    echo "Please start the frontend with: cd frontend && python3 -m http.server 3000"
    echo ""
fi

echo "========================================="
echo "Testing Backend API Endpoints"
echo "========================================="
echo ""

# Test backend endpoints
test_endpoint "Health Check" "http://localhost:8000/"
test_endpoint "Get Listings" "http://localhost:8000/api/listings"
test_endpoint "Auth Signup (POST)" "http://localhost:8000/api/auth/signup" 400
test_endpoint "Auth Login (POST)" "http://localhost:8000/api/auth/login" 400

echo ""
echo "========================================="
echo "Testing CORS Headers"
echo "========================================="
echo ""

# Test CORS
echo -n "Testing CORS headers... "
cors_header=$(curl -s -I -X OPTIONS http://localhost:8000/api/listings | grep -i "access-control-allow-origin")
if [ -n "$cors_header" ]; then
    echo -e "${GREEN}✓ PASSED${NC}"
    echo "  $cors_header"
    ((PASSED++))
else
    echo -e "${YELLOW}⚠ WARNING${NC} - CORS headers not found"
    echo "  Frontend may have issues connecting to backend"
fi

echo ""
echo "========================================="
echo "Testing Frontend Files"
echo "========================================="
echo ""

# Test frontend files
if curl -s http://localhost:3000/ > /dev/null 2>&1; then
    test_endpoint "Frontend Index" "http://localhost:3000/"
    test_endpoint "Frontend CSS" "http://localhost:3000/css/style.css"
    test_endpoint "Frontend Config JS" "http://localhost:3000/js/config.js"
    test_endpoint "Frontend API JS" "http://localhost:3000/js/api.js"
    test_endpoint "Frontend Auth JS" "http://localhost:3000/js/auth.js"
    test_endpoint "Frontend Listings JS" "http://localhost:3000/js/listings.js"
    test_endpoint "Frontend Main JS" "http://localhost:3000/js/main.js"
else
    echo -e "${YELLOW}⚠ Skipping frontend tests (frontend not running)${NC}"
fi

echo ""
echo "========================================="
echo "Testing API Data Format"
echo "========================================="
echo ""

# Test API response format
echo -n "Testing listings API response format... "
listings_response=$(curl -s http://localhost:8000/api/listings)
if echo "$listings_response" | python3 -c "import sys, json; data=json.load(sys.stdin); exit(0 if 'success' in data and 'data' in data else 1)" 2>/dev/null; then
    echo -e "${GREEN}✓ PASSED${NC}"
    echo "  Response has correct format (success, data fields)"
    ((PASSED++))
else
    echo -e "${RED}✗ FAILED${NC}"
    echo "  Response does not have expected format"
    ((FAILED++))
fi

echo ""
echo "========================================="
echo "Test Summary"
echo "========================================="
echo ""
echo -e "Total Tests: $((PASSED + FAILED))"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo ""
    echo "Your CompatHome application is ready!"
    echo ""
    echo "Access the application:"
    echo "  Frontend: http://localhost:3000"
    echo "  Backend:  http://localhost:8000"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    echo "Please check the errors above and fix them."
    echo ""
    exit 1
fi

