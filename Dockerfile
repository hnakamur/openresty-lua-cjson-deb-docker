# syntax=docker/dockerfile:1
ARG FROM=ubuntu:22.04
FROM ${FROM}

# Apapted from
# https://github.com/apache/trafficserver/blob/e4ff6cab0713f25290a62aba74b8e1a595b7bc30/ci/docker/deb/Dockerfile#L46-L58
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install tzdata apt-utils && \
    # Compilers
    DEBIAN_FRONTEND=noninteractive apt-get -y install \
    gcc make pkg-config \
    # tools to create deb packages
    debhelper dpkg-dev lsb-release xz-utils \
    git

ARG LUAJIT_DEB_VERSION
ARG LUAJIT_DEB_OS_ID
RUN mkdir -p /depends
RUN curl -sSL https://github.com/hnakamur/openresty-luajit-deb-docker/releases/download/${LUAJIT_DEB_VERSION}${LUAJIT_DEB_OS_ID}/openresty-luajit-${LUAJIT_DEB_VERSION}${LUAJIT_DEB_OS_ID}.tar.gz | tar zxf - -C /depends --strip-components=2
RUN dpkg -i /depends/*.deb

ARG SRC_DIR=/src
ARG BUILD_USER=build
RUN useradd -m -d ${SRC_DIR} ${BUILD_USER}

COPY --chown=${BUILD_USER}:${BUILD_USER} ./openresty-lua-cjson /src/openresty-lua-cjson/
USER ${BUILD_USER}
WORKDIR ${SRC_DIR}
ARG PKG_VERSION
RUN tar cf - --exclude=.git openresty-lua-cjson | xz -c -9 > openresty-lua-cjson_${PKG_VERSION}.orig.tar.xz

COPY --chown=${BUILD_USER}:${BUILD_USER} ./debian /src/openresty-lua-cjson/debian/
WORKDIR ${SRC_DIR}/openresty-lua-cjson
ARG PKG_REL_DISTRIB
RUN sed -i "s/DebRelDistrib/${PKG_REL_DISTRIB}/;s/UNRELEASED/$(lsb_release -cs)/" /src/openresty-lua-cjson/debian/changelog
RUN dpkg-buildpackage -us -uc

USER root
