FROM centos:6

RUN yum update -y \
 && yum install -y \
        autoconf \
        bzip2 \
        centos-release-SCL \
        curl \
        expect \
        gcc-c++ \
        git \
        glibc-devel \
        patch \
        procps \
        redhat-lsb-core \
        rpm-build \
        rpm-sign \
        which \
        zlib-devel \
  && rpm -ivh http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm \
  && yum --enablerepo=rpmforge-extras install -y git \
  && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && git config --global user.email "stackdriver-github-reader@google.com" \
  && git config --global user.name "stackdriverreader" \
  && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
  && /bin/bash -l -c "rvm requirements && rvm install 2.4 && gem install bundler --no-ri --no-rdoc && gem update"
