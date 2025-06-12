# Copyright (c) 2022 Cisco Systems, Inc. and others.
# All rights reserved.
FROM bgpdata/base:latest AS build

COPY . /ws
WORKDIR /ws

RUN rm -rf build && mkdir -p build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX:PATH=/usr ../ \
    && make \
    && make install

FROM debian:stable-slim

RUN apt-get update && apt-get install -y iproute2 libsasl2-2
RUN rm -rf /var/lib/apt/lists/*

ARG VERSION=0

COPY --chmod=755 --from=build /ws/scripts/run.sh /usr/sbin/run
COPY --chmod=755 --from=build /ws/scripts/install.sh /usr/sbin/install
COPY --chmod=755 --from=build /usr/bin/collectord /usr/bin/
COPY --from=build /usr/etc/bgpdata/collectord.conf /usr/etc/bgpdata/collectord.conf

# Install
RUN /usr/sbin/install

VOLUME ["/config"]

WORKDIR /tmp

CMD ["/usr/sbin/run"]

EXPOSE 5000         