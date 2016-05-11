FROM centos:centos7
MAINTAINER Joseph Pintozzi "joseph@pintozzi.com"

RUN yum -y update
RUN yum install -y mysql mysql-devel-5.1.69 unixODBC-devel \
      libxml2-devel libxslt-devel git-core zlib zlib-devel \
      readline readline-devel libyaml-devel libffi-devel \
      openssl-devel make bzip2 autoconf automake libtool \
      bison curl sqlite-devel mariadb-devel postgresql-devel \
      gcc-c++ patch
RUN yum clean all

# Install rbenv and ruby-build
ARG RUBY_VERSION
ENV RUBY_VERSION ${RUBY_VERSION:-2.3.0}

WORKDIR /usr/local
RUN git clone https://github.com/sstephenson/rbenv.git rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git rbenv/plugins/ruby-build
RUN /usr/local/rbenv/plugins/ruby-build/install.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

ENV CONFIGURE_OPTS --disable-install-doc
RUN bash -l -c 'rbenv install ${RUBY_VERSION}'

# bundler
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN bash -l -c 'rbenv global ${RUBY_VERSION}; gem install bundler'