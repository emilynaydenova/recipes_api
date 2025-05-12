# base Image - from local machine(downloaded and cashed) or from DokerHub
FROM python

# Ensure logs are displayed in real-time
ENV PYTHONUNBUFFERED=1
# Avoid cache to reduce image size
ENV PIP_NO_CACHE_DIR=1

ENV PATH="scripts:/py/bin:$PATH"
ARG DEV=false

# Set the working directory inside the container
WORKDIR /app

# Copy only the requirements first (for better caching)
COPY requirements.txt .
COPY requirements.dev.txt .
COPY scripts /scripts

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev gcc \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    liblcms2-dev \
    libopenjp2-7-dev \
    libtiff5-dev \
    tk-dev \
    tcl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    &&  rm -rf /var/lib/apt/lists/*
# libjpeg: For JPEG image support
# zlib: For PNG image support.
# libtiff: For TIFF image suppor
# freetype: For TrueType font support.
# littlecms: For color management.
# libwebp: For WebP image support.


# Install Python dependencies & create a non-root user &
# make static and media directories
RUN pip install -r requirements.txt && \
    if [ "$DEV" = "true" ];  \
    then pip install --no-cache-dir -r requirements.dev.txt; \
    fi && \
    useradd -m django-user && \
    mkdir -p /vol/web/media /vol/web/static && \
    chown -R django-user:django-user /vol && \
    chmod -R 755 /vol && \
    chmod -R +x /scripts

# /vol/web is the directory we want to use to store our media
# and static files and is mapped in docker_compose.yml

# fi is used to close an if statement in shell scripting (Bash)
# All from the current directory Must be copied into
# the image at WORKDIR(/app), without Dockerfile
COPY . .

# Django port 8000 available to the world outside this container
# the EXPOSE instruction is mainly informational
EXPOSE 8000
# Set the user to use when running the application
USER django-user
# Set the default command to run when starting the container
CMD ["run.sh"]
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

# set -ex: Adds debugging (-x) and error-failing (-e) modes
#to help during build.

