#!/usr/bin/env bash
set -e

chromium \
  $(cat /flags/ctv-base.flags) \
  $(cat /flags/profile.flags) \
  "$@"
