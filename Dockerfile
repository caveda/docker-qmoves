# Base image already runs python
FROM python:alpine3.6

RUN apk add --no-cache --virtual .build-deps gcc musl-dev

# Upgrade pip
RUN pip install --upgrade pip  && \
    pip install --upgrade setuptools

# Set timezone
RUN apk add --no-cache tzdata
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies of the python applications
COPY app/firestorage-publisher/requirements.txt /app/firestorage-publisher/
RUN pip install -r /app/firestorage-publisher/requirements.txt
COPY app/cocities-importer/requirements.txt /app/cocities-importer/
RUN pip install -r /app/cocities-importer/requirements.txt
COPY app/script-scheduler/requirements.txt /app/script-scheduler/
RUN pip install -r /app/script-scheduler/requirements.txt

# Copy applications
COPY app/ /app/
RUN mkdir /app/out/

# Set working dir
WORKDIR /app

# Define entrypoint application
ENTRYPOINT [ "python", "/app/script-scheduler/schedule-script.py", "/app/update-transit-data.sh"]
CMD ["22:00"]
