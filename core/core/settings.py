import os

# Determine the environment based on the environment variables
ENVIRONMENT = os.environ.get('DJANGO_ENVIRONMENT', 'development')

# Enter appropriate settings based on the environment
if ENVIRONMENT == 'production':
    from .envs.production import *
elif ENVIRONMENT == 'staging':
    from .envs.staging import *
else:
    from .envs.development import *
