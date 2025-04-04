#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Wait for database to be ready
echo "Waiting for postgres..."
while ! nc -z $DB_HOST $DB_PORT; do
  sleep 0.1
done
echo "PostgreSQL started successfully"

# Create log directory (for production environment)
if [ "$DJANGO_ENVIRONMENT" = "production" ]; then
    mkdir -p /var/log/django
    touch /var/log/django/error.log
    echo "Created log directory for production"
fi

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Create superuser if it doesn't exist
echo "Checking for superuser..."
python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin');
    print('Superuser created successfully');
else:
    print('Superuser already exists');
"

# Start server based on environment
if [ "$DJANGO_ENVIRONMENT" = "production" ]; then
    echo "Starting production server with gunicorn..."
    # Use gunicorn for production with optimized settings
    gunicorn core.wsgi:application --bind 0.0.0.0:8000 \
        --workers=4 \                # Number of workers: typically 2 * CPU cores + 1
        --threads=2 \                # Threads per worker
        --worker-class=gthread \     # Worker type: gthread performs better with django
        --worker-tmp-dir=/dev/shm \  # Use memory instead of disk for temp