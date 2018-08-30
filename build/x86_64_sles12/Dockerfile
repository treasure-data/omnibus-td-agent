FROM opensuse:42.3

RUN zypper -n refresh \
 && zypper -n install \
        autoconf \
        bzip2 \
        curl \
        expect \
        gcc-c++ \
        git \
        patch \
        procps \
        rpm-build \
        which \
        zlib-devel \
 && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
 && zypper -n clean \
 && git config --global user.email "stackdriver-github-reader@google.com" \
 && git config --global user.name "stackdriverreader" \
 && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
 && /bin/bash -l -c "rvm requirements && rvm install 2.4 && gem install bundler --no-ri --no-rdoc && gem update" \
 && /bin/sed -i -e 's/VERSION = 42.3/VERSION = 12/' /etc/SuSE-release \
 && /bin/sed -i -e 's/VERSION="42.3"/VERSION="12-SP3"/' -e 's/VERSION_ID="42.3"/VERSION_ID="12.3"/' /etc/os-release
