FROM debian:bookworm-slim

ARG CHROMIUM_VERSION

ENV DEBIAN_FRONTEND=noninteractive

# Core system deps
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

# Install Chromium
COPY install-chromium.sh /usr/local/bin/install-chromium.sh
RUN chmod +x /usr/local/bin/install-chromium.sh \
  && install-chromium.sh ${CHROMIUM_VERSION}

# Default display
ENV DISPLAY=:99

CMD ["bash"]
