$OPENSSH_VERSION="9.8p1"
$CENTOS_VERSION="8.2.2004"
docker build `
 --build-arg OPENSSH_VERSION=$OPENSSH_VERSION `
 --build-arg CENTOS_VERSION=$CENTOS_VERSION `
 -t centos-openssh:$CENTOS_VERSION-$OPENSSH_VERSION `
 .

if(!$?) { Exit $LASTEXITCODE }

docker run `
 --rm `
 -v "$(Get-Location)\rpms\openssh-${OPENSSH_VERSION}-${CENTOS_VERSION}:/root/rpms" `
 centos-openssh:$CENTOS_VERSION-$OPENSSH_VERSION `
 bash -c "cp /root/rpmbuild/RPMS/x86_64/*.rpm /root/rpms"
