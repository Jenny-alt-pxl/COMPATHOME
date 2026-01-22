#!/bin/bash

# CompatHome - Docker Helper Script
# This script provides easy access to Docker commands with proper PATH setup

# Add Docker to PATH
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to display usage
usage() {
    echo "CompatHome Docker Helper"
    echo ""
    echo "Usage: ./docker-helper.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start       - Start all services"
    echo "  stop        - Stop all services"
    echo "  restart     - Restart all services"
    echo "  status      - Show container status"
    echo "  logs        - View logs (follow mode)"
    echo "  logs-web    - View web service logs only"
    echo "  logs-db     - View database logs only"
    echo "  build       - Rebuild containers"
    echo "  clean       - Stop and remove all containers and volumes"
    echo "  shell       - Open shell in web container"
    echo "  db-shell    - Open PostgreSQL shell"
    echo "  test        - Run tests in container"
    echo "  verify      - Verify setup is working"
    echo ""
}

# Change to backend directory
cd backend 2>/dev/null || { echo "Error: backend directory not found"; exit 1; }

# Process command
case "$1" in
    start)
        echo -e "${BLUE}Starting CompatHome services...${NC}"
        docker compose up -d
        echo -e "${GREEN}✓ Services started${NC}"
        echo "API available at: http://localhost:8000"
        ;;
    
    stop)
        echo -e "${BLUE}Stopping CompatHome services...${NC}"
        docker compose down
        echo -e "${GREEN}✓ Services stopped${NC}"
        ;;
    
    restart)
        echo -e "${BLUE}Restarting CompatHome services...${NC}"
        docker compose restart
        echo -e "${GREEN}✓ Services restarted${NC}"
        ;;
    
    status)
        echo -e "${BLUE}Container Status:${NC}"
        docker compose ps
        ;;
    
    logs)
        echo -e "${BLUE}Viewing logs (Ctrl+C to exit)...${NC}"
        docker compose logs -f
        ;;
    
    logs-web)
        echo -e "${BLUE}Viewing web service logs (Ctrl+C to exit)...${NC}"
        docker compose logs -f web
        ;;
    
    logs-db)
        echo -e "${BLUE}Viewing database logs (Ctrl+C to exit)...${NC}"
        docker compose logs -f db
        ;;
    
    build)
        echo -e "${BLUE}Building containers...${NC}"
        docker compose build
        echo -e "${GREEN}✓ Build complete${NC}"
        ;;
    
    clean)
        echo -e "${YELLOW}Warning: This will remove all containers and volumes!${NC}"
        read -p "Are you sure? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker compose down -v
            echo -e "${GREEN}✓ Cleanup complete${NC}"
        else
            echo "Cancelled"
        fi
        ;;
    
    shell)
        echo -e "${BLUE}Opening shell in web container...${NC}"
        docker compose exec web /bin/bash
        ;;
    
    db-shell)
        echo -e "${BLUE}Opening PostgreSQL shell...${NC}"
        docker compose exec db psql -U compathome_user -d compathome_db
        ;;
    
    test)
        echo -e "${BLUE}Running tests...${NC}"
        docker compose exec web pytest tests/ -v
        ;;
    
    verify)
        echo -e "${BLUE}Verifying setup...${NC}"
        cd ..
        bash verify_docker_setup.sh
        ;;
    
    *)
        usage
        exit 1
        ;;
esac

