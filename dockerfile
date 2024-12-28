# Stage 1: Build stage (for arm64)
FROM python:3.8-slim

ARG DISCORD_TOKEN
ARG DISCORD_STREAMING_URL

WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY massacre_game_discord_bot.py /app/

# Set environment variables
ENV DISCORD_TOKEN=$DISCORD_TOKEN
ENV DISCORD_STREAMING_URL=$DISCORD_STREAMING_URL

# Command to run the application
CMD ["python", "-u", "massacre_game_discord_bot.py"]