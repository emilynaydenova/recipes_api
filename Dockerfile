# base Image - from local machine(downloaded and cashed) or from DokerHub
FROM python

# Ensure logs are displayed in real-time
ENV PYTHONUNBUFFERED=1
# Avoid cache to reduce image size
ENV PIP_NO_CACHE_DIR=1

ENV PATH="/py/bin:$PATH"
ARG DEV=false

# Set the working directory inside the container
WORKDIR /app

# Copy only the requirements first (for better caching)
COPY requirements.txt .
COPY requirements.dev.txt .

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev gcc && \
    rm -rf /var/lib/apt/lists/*



# Install Python dependencies
RUN pip install -r requirements.txt && \
    if [ "$DEV" = "true" ];  \
    then pip install -r requirements.dev.txt; \
    fi && \
    useradd -m django-user



# fi is used to close an if statement in shell scripting (Bash)
# All from the current directory Must be copied into
# the image at WORKDIR(/app), without Dockerfile
COPY . .

# Django port 8000 available to the world outside this container
# the EXPOSE instruction is mainly informational
EXPOSE 8000
# Set the user to use when running the application
USER django-user
#
## Run migrations and collect static files (optional)
#RUN python manage.py collectstatic --noinput
#
## Start the application using Gunicorn
#CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
#

# To force Docker to pull fresh images:
#  docker system prune -a
#  docker logout
#  docker login
#  docker compose up --build