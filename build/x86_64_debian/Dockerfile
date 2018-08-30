FROM debian:7

RUN apt-get update -y \
 && apt-get install -y \
        autoconf \
        bzip2 \
        curl \
        fakeroot \
        git \
        g++ \
        make \
        procps \
  && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && git config --global user.email "stackdriver-github-reader@google.com" \
  && git config --global user.name "stackdriverreader" \
  && (curl -sSL https://get.rvm.io | /bin/bash -s stable) \
  && /bin/bash -l -c "rvm requirements && rvm install 2.4 && gem install bundler --no-ri --no-rdoc && gem update"
