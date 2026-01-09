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

Browser versions are intentionally behind modern desktop Chrome. This reflects the reality of Connected TV platforms.

Each profile exposes its Chromium version as a **Docker build argument** so teams can pin or upgrade versions deliberately.

---

## What each profile simulates

All profiles intentionally enforce common CTV constraints:

* Arrow-key navigation only (↑ ↓ ← → Enter Back)
* No mouse or touch input
* No hover interactions
* Limited CPU and memory (profile-dependent)
* Older Chromium feature sets
* Media autoplay restrictions
* TV-like screen resolutions (720p / 1080p)

The goal is not perfection — it is **early failure**.

---

## Quick start (local)

Run your app inside a CTV browser profile:

```bash
docker run \
  -p 8080:8080 \
  ctv-browser-lab:android-tv
```

Point the container at your app and interact using arrow keys.

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
    docker build -t ctv-android-tv ./profiles/android-tv
    docker run ctv-android-tv npm test
```

Tests belong to **your application**, not this repository.

---

## Profile sanity checks

This repo includes lightweight **profile sanity checks** to ensure environments behave as advertised.

Examples:

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
