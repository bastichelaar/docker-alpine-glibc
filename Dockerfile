FROM alpine:3.4

LABEL image="metanic/alpine-glibc:3.4"
LABEL description="Adds GLIBC to Alpine linux"

ENV GLIBC_VERSION=2.23-r3

RUN \
  echo "Installing util packages..." && \
  apk update && \
  apk add tar ca-certificates curl && \
  echo "Downloading glibc..." && \
  for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; \
    do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; \
  done && \
  echo "Installing..." && \
  apk add --allow-untrusted /tmp/*.apk && \
  ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
  echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo "Cleaning up..." && \
  apk del tar ca-certificates curl && \
  rm -r /tmp/* /var/cache/apk/*
