FROM centos:7

RUN yum update -y \
 && yum install -y \
        autoconf \
        bzip2 \
        curl \
        expect \
        gcc-c++ \
        git \
        patch \
        procps \
        rpm-build \
        rpm-sign \
        which \
        zlib-devel \
  && curl -o fakeroot-libs.rpm "http://mirror.centos.org/centos/6/os/x86_64/Packages/fakeroot-libs-1.12.2-22.2.el6.x86_64.rpm" \
  && curl -o fakeroot.rpm "http://mirror.centos.org/centos/6/os/x86_64/Packages/fakeroot-1.12.2-22.2.el6.x86_64.rpm" \
  && rpm -i fakeroot.rpm fakeroot-libs.rpm \
  && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && git config --global user.email "stackdriver-github-reader@google.com" \
  && git config --global user.name "stackdriverreader" \
  && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
  && /bin/bash -l -c "rvm requirements && rvm install 2.4 && gem install bundler --no-ri --no-rdoc && gem update"
