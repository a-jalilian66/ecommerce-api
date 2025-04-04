#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Wait for database to be ready
#echo "Waiting for postgres..."
#while ! pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER; do
#  sleep 1
#done
#echo "PostgreSQL started successfully"

echo "Waiting for postgres..."
sleep 10
echo "PostgreSQL assumed ready"

# Create log directory (for production environment)
if [ "$DJANGO_ENVIRONMENT" = "production" ]; then
    mkdir -p /var/log/django
    touch /var/log/django/error.log
    chmod 777 /var/log/django/error.log
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
        --workers=4 \
        --threads=2 \
        --worker-class=gthread \
        --worker-tmp-dir=/dev/shm \
        --timeout=120 \
        --log-level=info
else
    echo "Starting development server..."
    python manage.py runserver 0.0.0.0:8000
fi