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
