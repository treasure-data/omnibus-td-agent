FROM opensuse/leap:42.3

RUN zypper -n refresh \
 && zypper -n install \
        autoconf \
        bzip2 \
        curl \
        expect \
        gcc-c++ \
        git \
        patch \
        ruby \
        rpm-build \
        which \
        zlib-devel \
  # RVM GPG keys.
 && gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
 # RVM requires running in a login shell.
 && /bin/bash -l -c "rvm requirements && rvm install 2.5.3 && gem install bundler --no-document && gem update" \
 # Pretend we're on SLES 12.
 && /bin/sed -i -e 's/VERSION = 42.3/VERSION = 12/' /etc/SuSE-release \
 && /bin/sed -i -e 's/VERSION="42.3"/VERSION="12-SP3"/' -e 's/VERSION_ID="42.3"/VERSION_ID="12.3"/' /etc/os-release \
 && zypper -n clean
