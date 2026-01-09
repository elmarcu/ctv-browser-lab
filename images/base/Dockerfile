FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Core system dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    xvfb \
    dbus \
    fonts-liberation \
    fonts-noto-color-emoji \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libxss1 \
    libasound2 \
    libgbm1 \
    libxdamage1 \
    libxrandr2 \
    libdrm2 \
  && rm -rf /var/lib/apt/lists/*

# Copy install script (used by profiles)
COPY install-chromium.sh /usr/local/bin/install-chromium.sh
RUN chmod +x /usr/local/bin/install-chromium.sh

# Default display for headless
ENV DISPLAY=:99

# Base image just sits there
CMD ["bash"]
