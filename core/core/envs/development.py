"""
Development environment specific settings.
This file special the settings required for the development environment.
"""
from .common import *  # Import All shared settings
from decouple import config, Csv

DEBUG = True

# Allowed domains are read from the environment file
ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='localhost,127.0.0.1', cast=Csv())

# Database settings for development environment
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DB_NAME', default='postgres'),
        'USER': config('DB_USER', default='postgres'),
        'PASSWORD': config('DB_PASSWORD', default='postgres'),
        'HOST': config('DB_HOST', default='db'),
        'PORT': config('DB_PORT', default='5432'),
    }
}

MIDDLEWARE += ['debug_toolbar.middleware.DebugToolbarMiddleware']
INSTALLED_APPS += ['debug_toolbar']
INTERNAL_IPS = ['127.0.0.1']

# Security settings - disabled in development environment
CSRF_COOKIE_SECURE = False
SESSION_COOKIE_SECURE = False
SECURE_SSL_REDIRECT = False

CORS_ALLOW_ALL_ORIGINS = True

# Swagger settings for API documentation
SWAGGER_SETTINGS = {
    'SECURITY_DEFINITIONS': {
        'Basic': {
            'type': 'basic'
        },
    },
    'USE_SESSION_AUTH': True,
    'JSON_EDITOR': True,
}
