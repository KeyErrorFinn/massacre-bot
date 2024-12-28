# Stage 1: Build stage (for arm64)
FROM python:3.8-alpine as build

# Install system dependencies
RUN apk add --no-cache --virtual .build-deps gcc musl-dev

ARG DISCORD_TOKEN
ARG DISCORD_STREAMING_URL

WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt . 
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final runtime image
FROM python:3.8-alpine

# Set environment variables
ENV DISCORD_TOKEN=${DISCORD_TOKEN}
ENV DISCORD_STREAMING_URL=${DISCORD_STREAMING_URL}

WORKDIR /app

# Copy installed dependencies from build image
COPY --from=build /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages

# Copy the application code
COPY massacre_game_discord_bot.py /app/

# Command to run the application
CMD ["python", "-u", "massacre_game_discord_bot.py"]