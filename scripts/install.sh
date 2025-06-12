#!/bin/bash
# Copyright (c) 2021 Cisco Systems, Inc. and others.
# All rights reserved.

# Add build details
touch /usr/local/version-${VERSION}

# Disable interactive
export DEBIAN_FRONTEND=noninteractive

# Install base packages
apt-get update

# Install dependencies
apt-get install -y iproute2 wget zlib1g libssl1.1 libsasl2-2

# Add host entries for reverse PTR lookups
if [[ -f /config/hosts ]]; then
    cat /config/hosts >> /etc/hosts
fi

# Cleanup
apt-get clean
rm -rf /var/lib/apt/lists/* /var/tmp/*