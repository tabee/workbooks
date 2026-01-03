#!/bin/bash
# Script to test the MkDocs Docker environment

set -e

echo "==================================="
echo "MkDocs Docker Environment Test"
echo "==================================="
echo ""

# Test 1: Build Docker image
echo "Test 1: Building Docker image..."
docker build -t mkdocs-env . || {
    echo "❌ Failed to build Docker image"
    exit 1
}
echo "✅ Docker image built successfully"
echo ""

# Test 2: Check MkDocs version
echo "Test 2: Checking MkDocs version..."
docker run --rm mkdocs-env mkdocs --version || {
    echo "❌ Failed to run MkDocs"
    exit 1
}
echo "✅ MkDocs is working"
echo ""

# Test 3: Create a test project
echo "Test 3: Creating a test project..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Copy example config
cp "$OLDPWD/mkdocs.yml.example" mkdocs.yml

# Create sample docs
mkdir -p docs
cat > docs/index.md << 'EOF'
# Welcome to Test Documentation

This is a test page to verify the MkDocs Docker environment.

## Features

* MkDocs is running
* Material theme is available
* Plugins are installed

!!! note
    This is an admonition block to test pymdownx extensions.
EOF

cat > docs/about.md << 'EOF'
# About

This is the about page.
EOF

echo "✅ Test project created in $TEMP_DIR"
echo ""

# Test 4: Build the test project
echo "Test 4: Building documentation..."
docker run --rm -v "$TEMP_DIR:/docs" mkdocs-env mkdocs build || {
    echo "❌ Failed to build documentation"
    exit 1
}
echo "✅ Documentation built successfully"
echo ""

# Test 5: Check if site was generated
echo "Test 5: Verifying output..."
if [ -d "$TEMP_DIR/site" ]; then
    echo "✅ Site directory created"
    echo "Generated files:"
    ls -la "$TEMP_DIR/site" | head -10
else
    echo "❌ Site directory not found"
    exit 1
fi
echo ""

# Cleanup
echo "Cleaning up test directory: $TEMP_DIR"
rm -rf "$TEMP_DIR"

echo ""
echo "==================================="
echo "✅ All tests passed!"
echo "==================================="
echo ""
echo "You can now use the MkDocs Docker environment:"
echo "  docker run -it --rm -p 8000:8000 -v \$(pwd):/docs mkdocs-env"
echo ""
echo "Or use docker-compose:"
echo "  docker-compose up"
echo ""
