FROM centos:6

# CentOS 6 is EOL, so we have to switch to the vault repos.
RUN sed -i \
        -e 's%^mirrorlist%#mirrorlist%' \
        -e 's%^# *baseurl=http://mirror%baseurl=http://vault%' \
        /etc/yum.repos.d/CentOS-*.repo

RUN yum -y update \
 && yum -y install \
        # Needed for gpg2 and rvm installation.
        curl \
        # Needed for agent build.
        autoconf \
        bzip2 \
        centos-release-SCL \
        expect \
        gcc-c++ \
        git \
        glibc-devel \
        patch \
        redhat-lsb-core \
        rpm-build \
        rpm-sign \
        ruby \
        which \
        zlib-devel \
 # CentOS 6 comes with git 1.7.1, and omnibus requires at least 1.7.2.
 && rpm -ivh http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm \
 && yum --enablerepo=rpmforge-extras -y upgrade git \
 # RVM GPG keys.
 && mkdir -p ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
 && gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
 # RVM requires running in a login shell.
 && /bin/bash -l -c "rvm requirements && rvm install 2.5.3 && gem install bundler --no-document && gem update" \
 && yum -y clean all
