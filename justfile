# Install dependencies and dev dependencies
install:
    uv pip install -r requirements.txt -r requirements-dev.txt

# Check django
check:
    python manage.py check

# Make database migrations
make-migrations:
    python manage.py makemigrations

# Add migrations to the database
migrate:
    python manage.py migrate

# Run python server
run:
    python manage.py runserver
