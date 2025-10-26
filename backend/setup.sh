#!/bin/bash

echo "🚀 Setting up Trackr Backend..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install it first:"
    echo "   brew install node"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "⚠️  PostgreSQL not found. Installing with Homebrew..."
    brew install postgresql@14
    brew services start postgresql@14
fi

# Create database
echo "🗄️  Creating database..."
createdb trackr 2>/dev/null || echo "Database 'trackr' already exists"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << EOF
DB_USER=postgres
DB_HOST=localhost
DB_NAME=trackr
DB_PASSWORD=postgres
DB_PORT=5432
PORT=3000
EOF
fi

echo "✅ Setup complete!"
echo ""
echo "To start the backend server:"
echo "  cd backend"
echo "  npm run dev"
echo ""
echo "The API will be available at http://localhost:3000"

