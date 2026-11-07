# Install dependencies and dev dependencies
install:
    uv pip install -r requirements.txt -r requirements-dev.txt

# Check django
check:
    python manage.py check

