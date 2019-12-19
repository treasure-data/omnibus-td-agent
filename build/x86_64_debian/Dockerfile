FROM debian:7

RUN \
 # Point to the archive...
    sed -i \
      -e 's/\(deb\|httpredir\)\.debian\.org/archive.debian.org/g' \
      -e '/-updates main/d' \
      -e '/http\.debian\.net/d' \
      /etc/apt/sources.list \
 # ...and disable the expiration check...
 && echo 'Acquire::Check-Valid-Until "0";' \
      >/etc/apt/apt.conf.d/10no-check-valid-until \
 # ...and remove pointers to the defunct security repos.
 && sed -i \
      -e '/security\.debian\.org/d' \
      /etc/apt/sources.list

RUN apt-get -y update \
 # Needed for autoconf, due to broken Debian 7 repos.
 && apt-get -y -o Apt::Get::force-yes=1 install perl-base=5.14.2-21+deb7u3 \
 # Needed for g++, due to broken Debian 7 repos.
 && apt-get download libc-bin=2.13-38+deb7u10 \
 && dpkg -i libc-bin_2.13-38+deb7u10_amd64.deb \
 && apt-get download libc6=2.13-38+deb7u10 \
 && dpkg -i libc6_2.13-38+deb7u10_amd64.deb \
 && apt-get -y install linux-libc-dev \
 # Needed for rvm, due to broken Debian 7 repos.
 && apt-get -y install gnupg2 procps \
 && apt-get download libssl1.0.0=1.0.1e-2+deb7u20 \
 && dpkg -i libssl1.0.0_1.0.1e-2+deb7u20_amd64.deb \
 # Clean up all the downloaded packages.
 && rm -f *.deb \
 # Now install the necessary packages.
 && apt-get -y install \
        autoconf \
        bzip2 \
        curl \
        fakeroot \
        git \
        g++ \
        make \
        ruby \
 # RVM GPG keys.
 && gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
 && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
 # RVM requires running in a login shell.
 && /bin/bash -l -c "rvm requirements && rvm install 2.5.3 && gem install bundler --no-document && gem update" \
 && apt-get -y clean
