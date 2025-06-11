# Copyright (c) 2022 Cisco Systems, Inc. and others.
# All rights reserved.
FROM openbmp/dev-image:latest AS build

COPY obmp-collector/ /ws
WORKDIR /ws

RUN rm -rf build && mkdir -p build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX:PATH=/usr ../ \
    && make \
    && make install

FROM debian:stable-slim

ADD --chmod=755 obmp-docker/collector/scripts/install /tmp/
ADD --chmod=755 obmp-docker/collector/scripts/run /usr/sbin/

ARG VERSION=0

COPY --chmod=755 --from=build /usr/bin/openbmpd /usr/bin/
COPY --from=build /usr/etc/openbmp/openbmpd.conf /usr/etc/openbmp/openbmpd.conf

# Install
RUN /tmp/install

VOLUME ["/config"]

WORKDIR /tmp

CMD ["/usr/sbin/run"]

EXPOSE 5000         