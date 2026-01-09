# ctv-browser-lab

A Docker-based simulation lab for testing web applications against real-world Connected TV (CTV) browser environments.

This project exists because **desktop Chrome is a lie** when you ship to TVs.

---

## Why CTV testing is broken

Connected TV platforms run:

* Old Chromium forks
* Vendor-modified WebViews
* Slow CPUs and tight memory limits
* Remote-control navigation instead of mouse/touch

Most teams:

* Develop on modern desktop browsers
* Discover issues late on physical TVs
* Debug layout, focus, and media bugs under pressure

This repo provides **repeatable, local, and CI-friendly browser profiles** that approximate how CTV browsers actually behave.

---

## What this project is

`ctv-browser-lab` provides:

* Docker images that simulate **real-world CTV browser environments**
* Opinionated browser profiles mapped to common TV platforms
* A way to run your existing app and tests:

  * Locally
  * In CI

The goal is to catch:

* Layout regressions
* JavaScript compatibility issues
* Media playback failures
* Focus and navigation bugs

**before** you deploy to real devices.

---

## What this project is NOT

Be very clear about expectations:

* ❌ Not a hardware emulator
* ❌ Not a pixel-perfect TV renderer
* ❌ Not a test framework
* ❌ Not a replacement for real device QA

This project provides **browser-level approximations**, not full platform emulation.

You should still test on real TVs before release.

---

## Supported browser profiles (v1)

These profiles represent **device classes**, not "latest" browsers.

| Profile       | Default Chromium | Real-world target                         |
| ------------- | ---------------- | ----------------------------------------- |
| Android TV    | 90               | Android 9–11 TVs, WebView-based platforms |
| Samsung Tizen | 80               | 2018–2021 Samsung Smart TVs               |
| LG WebOS      | 84               | Mid-generation LG WebOS TVs               |
| Worst Case    | 72               | Low-end hardware still in production      |

Browser versions are intentionally behind modern desktop Chrome. Each profile exposes its Chromium version as a **Docker build argument** so teams can pin or upgrade versions deliberately.

All profiles enforce common CTV constraints:

* Arrow-key navigation only (↑ ↓ ← → Enter Back)
* No mouse or touch input
* No hover interactions
* Limited CPU and memory (profile-dependent)
* Older Chromium feature sets
* Media autoplay restrictions
* TV-like screen resolutions (720p / 1080p)

The goal is not perfection — it is **early failure**.

---

## v1 MVP Structure

```
images/
├── base/
│   └── Dockerfile            # Generic base image (no Chromium installed)
│   └── install-chromium.sh   # Script for installing Chromium per profile
├── ctv-profile/
│   ├── Dockerfile            # Generic profile Dockerfile (installs Chromium + flags)
│   └── entrypoint.sh         # Shared entrypoint reading flags

flags/
├── ctv-base.flags             # Flags applied to all CTVs
├── android-tv.flags           # Profile-specific flags
├── tizen.flags
├── webos.flags
└── low-end.flags

docker-compose.yml
```

### Base Dockerfile (`images/base/Dockerfile`)

```dockerfile
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

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

COPY install-chromium.sh /usr/local/bin/install-chromium.sh
RUN chmod +x /usr/local/bin/install-chromium.sh

ENV DISPLAY=:99
CMD ["bash"]
```

### Profile Dockerfile (`images/ctv-profile/Dockerfile`)

```dockerfile
FROM ctv-browser-lab-base

ARG DEVICE_NAME
ARG CHROMIUM_VERSION

# install Chromium per profile
RUN install-chromium.sh $CHROMIUM_VERSION

COPY ../../flags/ctv-base.flags /flags/ctv-base.flags
COPY ../../flags/${DEVICE_NAME}.flags /flags/profile.flags
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```

### Entrypoint (`images/ctv-profile/entrypoint.sh`)

```bash
#!/usr/bin/env bash
set -e

chromium \
  $(cat /flags/ctv-base.flags) \
  $(cat /flags/profile.flags) \
  "$@"
```

---

## Quick start (local)

Run your app inside a CTV browser profile:

```bash
export DEVICE_NAME=android-tv
export CHROMIUM_VERSION=90

docker-compose build device
docker-compose run --rm device
```

---

## Using in CI

The simulator is designed to run **your existing tests**.

Typical CI usage:

* Build a CTV profile image
* Start your app inside it
* Run your app's unit / integration / e2e tests

Example (GitHub Actions):

```yaml
- name: Run tests in Android TV profile
  run: |
    docker-compose build device
    docker-compose run --rm device npm test
```

Tests belong to **your application**, not this repository.

---

## Profile sanity checks

Lightweight **sanity checks** ensure environments behave as advertised:

* Focus moves only via arrow keys
* Autoplay fails without user interaction
* Certain modern APIs are unavailable in older profiles
* Resource limits are enforced

These checks validate the simulator itself — not your app.

---

## Known limitations

* No DRM / Widevine support
* No vendor-specific JS APIs
* No accurate GPU emulation
* Media performance may differ from physical devices

If you need exact behavior, test on real hardware.

---

## Adding New Devices

1. Create a new flags file in `flags/` (e.g., `fire-tv.flags`).
2. Use the same `ctv-profile/Dockerfile` and `entrypoint.sh` — no new Dockerfile needed.
3. Pass `DEVICE_NAME=fire-tv` and desired `CHROMIUM_VERSION` when building.

---

## When to use this

Use `ctv-browser-lab` when you:

* Ship web apps to TVs
* Support multiple CTV platforms
* Want earlier feedback than device labs provide
* Need reproducible CTV failures in CI

If you only target modern desktop browsers, this repo is not for you.

---

## Project philosophy

This project is:

* Opinionated
* Minimal
* Production-driven

If a feature does not reflect real CTV pain, it does not belong here.
