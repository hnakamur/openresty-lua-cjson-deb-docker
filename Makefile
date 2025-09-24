PKG_ARCHIVE_NAME=openresty-lua-cjson
PKG_VERSION=2.1.0.9
PKG_REL_PREFIX=1hn1
ifdef NO_CACHE
DOCKER_NO_CACHE=--no-cache
endif

LUAJIT_DEB_VERSION=2.1.20250826-1hn1

# Ubuntu 24.04
deb-ubuntu2404: build-ubuntu2404
	docker run --rm -v ./${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu24.04:/dist lua-cjson-ubuntu2404 bash -c \
	"install /src/*${PKG_VERSION}* /dist/"
	tar zcf ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu24.04.tar.gz ./${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu24.04/

build-ubuntu2404:
	sudo mkdir -p ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu24.04
	PKG_REL_DISTRIB=ubuntu24.04; \
	(set -x; \
	docker buildx build --load --progress=plain ${DOCKER_NO_CACHE} \
		--build-arg FROM=ubuntu:24.04 \
		--build-arg PKG_VERSION=${PKG_VERSION} \
		--build-arg PKG_REL_DISTRIB=ubuntu24.04 \
		--build-arg LUAJIT_DEB_VERSION=${LUAJIT_DEB_VERSION} \
		--build-arg LUAJIT_DEB_OS_ID=ubuntu24.04 \
		-t lua-cjson-ubuntu2404 . \
	) 2>&1 | sudo tee ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu24.04/lua-cjson_${PKG_VERSION}-${PKG_REL_PREFIX}$${PKG_REL_DISTRIB}.build.log&& \
	sudo xz -9 --force ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu24.04/lua-cjson_${PKG_VERSION}-${PKG_REL_PREFIX}$${PKG_REL_DISTRIB}.build.log

run-ubuntu2404:
	docker run --rm -it lua-cjson-ubuntu2404 bash

# Ubuntu 22.04
deb-ubuntu2204: build-ubuntu2204
	docker run --rm -v ./${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu22.04:/dist lua-cjson-ubuntu2204 bash -c \
	"install /src/*${PKG_VERSION}* /dist/"
	tar zcf ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu22.04.tar.gz ./${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu22.04/

build-ubuntu2204:
	sudo mkdir -p ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu22.04
	PKG_REL_DISTRIB=ubuntu22.04; \
	(set -x; \
	docker buildx build --load --progress=plain ${DOCKER_NO_CACHE} \
		--build-arg FROM=ubuntu:22.04 \
		--build-arg PKG_VERSION=${PKG_VERSION} \
		--build-arg PKG_REL_DISTRIB=ubuntu22.04 \
		--build-arg LUAJIT_DEB_VERSION=${LUAJIT_DEB_VERSION} \
		--build-arg LUAJIT_DEB_OS_ID=ubuntu22.04 \
		-t lua-cjson-ubuntu2204 . \
	) 2>&1 | sudo tee ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu22.04/lua-cjson_${PKG_VERSION}-${PKG_REL_PREFIX}$${PKG_REL_DISTRIB}.build.log&& \
	sudo xz -9 --force ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}ubuntu22.04/lua-cjson_${PKG_VERSION}-${PKG_REL_PREFIX}$${PKG_REL_DISTRIB}.build.log

run-ubuntu2204:
	docker run --rm -it lua-cjson-ubuntu2204 bash

# Debian 12
deb-debian12: build-debian12
	docker run --rm -v ./${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}debian12:/dist lua-cjson-debian12 bash -c \
	"install /src/*${PKG_VERSION}* /dist/"
	tar zcf ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}debian12.tar.gz ./${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}debian12/

build-debian12:
	sudo mkdir -p ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}debian12
	PKG_REL_DISTRIB=debian12; \
	(set -x; \
	docker buildx build --load --progress=plain ${DOCKER_NO_CACHE} \
		--build-arg FROM=debian:12 \
		--build-arg PKG_VERSION=${PKG_VERSION} \
		--build-arg PKG_REL_DISTRIB=debian12 \
		--build-arg LUAJIT_DEB_VERSION=${LUAJIT_DEB_VERSION} \
		--build-arg LUAJIT_DEB_OS_ID=debian12 \
		-t lua-cjson-debian12 . \
	) 2>&1 | sudo tee ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}debian12/lua-cjson_${PKG_VERSION}-${PKG_REL_PREFIX}$${PKG_REL_DISTRIB}.build.log && \
	sudo xz -9 --force ${PKG_ARCHIVE_NAME}-${PKG_VERSION}-${PKG_REL_PREFIX}debian12/lua-cjson_${PKG_VERSION}-${PKG_REL_PREFIX}$${PKG_REL_DISTRIB}.build.log

run-debian12:
	docker run --rm -it lua-cjson-debian12 bash

exec:
	docker exec -it $$(docker ps -q) bash

.PHONY: deb-ubuntu2404 build-ubuntu2404 run-ubuntu2404 deb-ubuntu2204 build-ubuntu2204 run-ubuntu2204 deb-debian12 build-debian12 run-debian12 exec
