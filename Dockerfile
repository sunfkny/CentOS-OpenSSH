ARG CENTOS_VERSION=8.2.2004
FROM centos:${CENTOS_VERSION}

# use aliyun mirror
ARG CENTOS_VERSION=8.2.2004
RUN sed -e "s|^mirrorlist=|#mirrorlist=|g" \
    -e "s|^#baseurl=http://mirror.centos.org/\$contentdir/\$releasever|baseurl=https://mirrors.aliyun.com/centos-vault/$CENTOS_VERSION|g" \
    -i.bak \
    /etc/yum.repos.d/CentOS-*.repo && \
    yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm && \
    sed -i 's|^#baseurl=https://download.example/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel* && \
    sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel* && \
    yum makecache && \
    yum install -y epel-release

# install dependencies
RUN yum -y install wget rpm-build zlib-devel openssl-devel gcc perl perl-devel pam-devel

# download sources
ARG OPENSSH_VERSION=9.6p1
RUN mkdir -p /root/rpmbuild/{SOURCES,SPECS} && \
    cd /root/rpmbuild/SOURCES && \
    wget https://mirrors.aliyun.com/openssh/portable/openssh-${OPENSSH_VERSION}.tar.gz && \
    wget https://src.fedoraproject.org/repo/pkgs/openssh/x11-ssh-askpass-1.2.4.1.tar.gz/8f2e41f3f7eaa8543a2440454637f3c3/x11-ssh-askpass-1.2.4.1.tar.gz && \
    tar zxvf openssh-${OPENSSH_VERSION}.tar.gz openssh-${OPENSSH_VERSION}/contrib/redhat/openssh.spec && \
    mv openssh-${OPENSSH_VERSION}/contrib/redhat/openssh.spec ../SPECS/

# build
RUN cd /root/rpmbuild/SPECS/ && \
    sed -i 's|^BuildRequires: openssl-devel < 1.1|#BuildRequires: openssl-devel < 1.1|' openssh.spec && \
    rpmbuild -ba openssh.spec \
    --define 'skip_gnome_askpass 1' \
    --define 'skip_x11_askpass 1'
