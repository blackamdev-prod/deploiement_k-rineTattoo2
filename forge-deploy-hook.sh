#!/bin/bash

cd $FORGE_SITE_PATH

echo "=== FORGE DEPLOYMENT START ==="

# Standard Laravel Forge deployment
git pull origin main
$FORGE_COMPOSER install --no-interaction --prefer-dist --optimize-autoloader

# CRITICAL: Ensure image directories exist and copy images
echo "Setting up image assets..."
mkdir -p public/assets/images
mkdir -p public/assets/images/portfolio
mkdir -p storage/app/public/assets/images

# Copy main artiste image from repository root to public (primary location)
if [ -f "artiste.png" ]; then
    cp artiste.png public/assets/images/artiste.png
    echo "✓ Artiste image copied to public/assets/images/"
else
    echo "⚠ Warning: artiste.png not found in repository root"
fi

# Copy portfolio images if they exist
if [ -d "public/images/portfolio" ]; then
    cp -r public/images/portfolio/* public/assets/images/portfolio/
    echo "✓ Portfolio images copied to public/assets/images/portfolio/"
else
    echo "⚠ Warning: public/images/portfolio directory not found"
fi

# Remove macOS extended attributes that can cause deployment issues
if [ -d "public/assets/images/portfolio" ]; then
    xattr -cr public/assets/images/portfolio/ 2>/dev/null || true
    echo "✓ Removed extended attributes from portfolio images"
fi

# Ensure correct image extensions (rename .png to .jpg if needed)
if [ -d "public/assets/images/portfolio" ]; then
    for file in public/assets/images/portfolio/*.png; do
        if [ -f "$file" ]; then
            mv "$file" "${file%.png}.jpg"
            echo "✓ Renamed $(basename "$file") to $(basename "${file%.png}.jpg")"
        fi
    done
fi

# Create multiple copies of problematic images for maximum reliability
echo "Creating multiple fallback copies for problematic images..."

# For image4 (Phoenix Aquarelle)
if [ -f "public/images/portfolio/image4.png" ]; then
    # Copy to multiple locations
    cp "public/images/portfolio/image4.png" "public/assets/images/portfolio/image4.jpg"
    cp "public/images/portfolio/image4.png" "public/assets/images/portfolio/image4.png"
    cp "public/images/portfolio/image4.png" "public/images/portfolio/image4.jpg"
    echo "✓ image4 copied to multiple fallback locations"
fi

# For image6 (Portrait Réaliste)  
if [ -f "public/images/portfolio/image6.png" ]; then
    # Copy to multiple locations
    cp "public/images/portfolio/image6.png" "public/assets/images/portfolio/image6.jpg"
    cp "public/images/portfolio/image6.png" "public/assets/images/portfolio/image6.png"
    cp "public/images/portfolio/image6.png" "public/images/portfolio/image6.jpg"
    echo "✓ image6 copied to multiple fallback locations"
fi

# Verify all copies exist
echo "Verifying all image copies..."
for location in "public/assets/images/portfolio" "public/images/portfolio"; do
    for img in image4.jpg image4.png image6.jpg image6.png; do
        if [ -f "$location/$img" ]; then
            echo "✓ $location/$img exists ($(stat -c%s "$location/$img" 2>/dev/null || stat -f%z "$location/$img") bytes)"
        else
            echo "✗ $location/$img MISSING"
        fi
    done
done

# Also copy to storage (backup location)
if [ -f "public/assets/images/artiste.png" ]; then
    cp public/assets/images/artiste.png storage/app/public/assets/images/artiste.png
    echo "✓ Image copied to storage backup location"
fi

# Ensure storage link exists
if [ ! -L "public/storage" ]; then
    $FORGE_PHP artisan storage:link
    echo "✓ Storage link created"
else
    echo "✓ Storage link already exists"
fi

# Set correct permissions BEFORE clearing cache
echo "Setting permissions..."
chmod -R 755 public/assets/ 2>/dev/null || true
chmod -R 755 storage/app/public/assets/ 2>/dev/null || true
chmod 644 public/assets/images/* 2>/dev/null || true
chmod 644 storage/app/public/assets/images/* 2>/dev/null || true

# Clear all caches
echo "Clearing caches..."
$FORGE_PHP artisan config:clear
$FORGE_PHP artisan cache:clear
$FORGE_PHP artisan view:clear
$FORGE_PHP artisan route:clear

# Optimize for production
echo "Optimizing for production..."
$FORGE_PHP artisan config:cache
$FORGE_PHP artisan route:cache
$FORGE_PHP artisan view:cache

# Verify image exists
echo "Verifying image deployment..."
if [ -f "public/assets/images/artiste.png" ]; then
    echo "✓ Image successfully deployed to public/assets/images/"
    ls -la public/assets/images/artiste.png
else
    echo "✗ Image NOT found in public/assets/images/"
fi

if [ -f "storage/app/public/assets/images/artiste.png" ]; then
    echo "✓ Backup image exists in storage/"
else
    echo "✗ Backup image NOT found in storage/"
fi

echo "=== FORGE DEPLOYMENT COMPLETED ==="