# Use a Python base image with Alpine for smaller size
FROM python:3.8-alpine as build

# Install dependencies for building Python packages
RUN apk add --no-cache --virtual .build-deps gcc musl-dev

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install dependencies from requirements.txt
RUN pip install -r requirements.txt

# Start a new stage for the final image (to keep it smaller)
FROM python:3.8-alpine

# Set the working directory in the final image
WORKDIR /app

# Copy over installed dependencies from the build stage
COPY --from=build /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages

# Copy the Python bot script into the final image
COPY massacre_game_discord_bot.py /app/

# Set environment variables (for security, use build args or docker secrets)
ARG DISCORD_TOKEN
ARG DISCORD_STREAMING_URL
ENV DISCORD_TOKEN=${DISCORD_TOKEN}
ENV DISCORD_STREAMING_URL=${DISCORD_STREAMING_URL}

# Command to run the bot (you can change this based on your needs)
CMD ["python", "massacre_game_discord_bot.py"]