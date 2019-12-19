FROM centos:6

RUN yum -y update \
 && yum -y install \
        autoconf \
        bzip2 \
        centos-release-SCL \
        curl \
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
 && rpm -ivh http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm \
 && yum --enablerepo=rpmforge-extras install -y git \
 # RVM GPG keys.
 && gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
 # RVM requires running in a login shell.
 && /bin/bash -l -c "rvm requirements && rvm install 2.5.3 && gem install bundler --no-document && gem update" \
 && yum -y clean all
