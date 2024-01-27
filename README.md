# CentOS-OpenSSH

## Build
```powershell
./build.ps1
```
or
```bash
./build.sh
```

## Install
```bash
# disable selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
# update openssh
rpm -Uvh openssh-*.rpm
# enable root login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# start sshd
systemctl restart sshd
systemctl status sshd
```

## See also
[boypt/openssh-rpms](https://github.com/boypt/openssh-rpms)
