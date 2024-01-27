#!/bin/bash
set -e
OPENSSH_VERSION="9.6p1"
CENTOS_VERSION="8.2.2004"
docker build \
 --build-arg OPENSSH_VERSION=$OPENSSH_VERSION \
 --build-arg CENTOS_VERSION=$CENTOS_VERSION \
 -t centos-openssh:$OPENSSH_VERSION-$CENTOS_VERSION \
 .

docker run \
 --rm \
 -v "$(pwd)/rpms/openssh-${OPENSSH_VERSION}-${CENTOS_VERSION}:/root/rpms" \
 centos-openssh:$OPENSSH_VERSION-$CENTOS_VERSION \
 bash -c "cp /root/rpmbuild/RPMS/x86_64/*.rpm /root/rpms"
