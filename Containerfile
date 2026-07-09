# SPDX-FileCopyrightText: © 2026 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="Ampache" \
        org.opencontainers.image.description="Web based audio file manager and media server" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/ampache" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-ampache.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    AMPACHE_VERSION="79e09fc30eef32133b38d6d884c5e0760c9dfef0" \
    AMPACHE_REPO_URL="https://github.com/ampache/ampache"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    IMAGE_NAME="nfrastack/ampache" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-ampache/"

RUN echo "" && \
    BUILD_ENV=" \
                10-nginx/NGINX_SITE_ENABLED=ampache \
                10-nginx/NGINX_SITE_AMPACHE_WEBROOT=/www/ampache \
                10-nginx/NGINX_SITE_AMPACHE_WEBROOT_SUFFIX=/public \
                10-nginx/NGINX_USER=ampache \
                10-nginx/NGINX_GROUP=ampache \
                20-php-fpm/PHP_CREATE_SAMPLE_PHP=FALSE \
                20-php-fpm/PHP_MODULE_ENABLE_FILEINFO=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_GETTEXT=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_HASH=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_LDAP=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_MBSTRING=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_SESSION=TRUE \
                20-php-fpm/PHP_MODULE_ENABLE_ZIP=TRUE \
                " \
                && \
    AMPACHE_BUILD_DEPS_ALPINE=" \
                                " \
                                && \
    AMPACHE_RUN_DEPS_ALPINE=" \
                                ffmpeg \
                                ffmpeg-libavcodec \
                                flac \
                                inotify-tools \
                                lame \
                                libflac \
                                libtheora \
                                libvorbis \
                                libvpx \
                                nodejs \
                                npm \
                                unzip  \
                                vorbis-tools \
                                zip \
                            " \
                            && \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user ampache 1000 ampache 1000 /media && \
    add_user_group ampache www-data && \
    package update && \
    package upgrade && \
    package install \
                     AMPACHE_RUN_DEPS \
                     && \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    clone_git_repo "${AMPACHE_REPO_URL}" "${AMPACHE_VERSION}" ${NGINX_SITE_AMPACHE_WEBROOT} && \
    mkdir -p /container/data/ampache/config && \
    cp "${NGINX_SITE_AMPACHE_WEBROOT}"/config/ampache.cfg.php.dist /container/data/ampache/config/ && \
    composer install --no-dev --prefer-source --no-interaction && \
    composer require szymach/c-pchart "3.*" && \
    npm install && \
    npm run build && \
    rm -rf \
            "${NGINX_SITE_AMPACHE_WEBROOT}"/.git \
            "${NGINX_SITE_AMPACHE_WEBROOT}"/config \
            "${NGINX_SITE_AMPACHE_WEBROOT}"/CONTRIBUTING.md \
            "${NGINX_SITE_AMPACHE_WEBROOT}"/docker \
            "${NGINX_SITE_AMPACHE_WEBROOT}"/phpstan* \
            "${NGINX_SITE_AMPACHE_WEBROOT}"/phpunit.xml \
            && \
    container_build_log add "Ampache" "${AMPACHE_VERSION}" "${AMPACHE_REPO_URL}" && \
    package cleanup

COPY rootfs /
