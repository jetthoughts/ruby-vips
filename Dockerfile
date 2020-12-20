ARG ubuntu_version=20.04
FROM ubuntu:${ubuntu_version}

RUN groupadd -r appgroup &&\
    useradd -m -r -g appgroup app

RUN mkdir -p /home/app
RUN chown -R app:appgroup /home/app
RUN chmod a+w+r /home/app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq &&\
    apt-get upgrade -qq -y &&\
    apt-get install -qq --no-install-recommends -y apt-utils autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev &&\
    apt-get install -qq --no-install-recommends -y git build-essential automake libtool swig  libxml2-dev libfftw3-dev \
                                                    libmagickwand-dev libopenexr-dev liborc-0.4-0 gobject-introspection libgsf-1-dev \
                                                    libglib2.0-dev liborc-0.4-dev gtk-doc-tools libopenslide-dev libmatio-dev libgif-dev libwebp-dev libjpeg-turbo8-dev libexpat1-dev &&\
    apt-get install -qq -y ca-certificates clang curl git libc++-dev libc++abi-dev libssl-dev libz-dev libomp-dev llvm llvm-6.0-dev &&\
    apt-get install -qq -y libvips libvips-dev libvips-tools &&\
    apt-get install -qq -y gettext libwebp-dev libtiff5-dev libjpeg-turbo8-dev liblcms2-dev libmagickwand-dev libmagick++-dev &&\
    apt-get install -qq -y locales locales-all &&\
    apt-get autoremove -y -qq &&\
    apt-get clean -y -qq &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

ENV HOME=/home/app
ENV RBENV_ROOT=/home/app/.rbenv

USER app

RUN git clone git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} &&\
    git clone git://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build

ENV PATH=$RBENV_ROOT/shims:$RBENV_ROOT/bin:$RBENV_ROOT/plugins/ruby-build/bin:$PATH

#2.5.8
#2.6.6
#2.7.2
#jruby-9.2.13.0
#mruby-2.1.2
#rbx-5.0
#truffleruby-20.3.0
#truffleruby+graalvm-20.3.0
ARG rbenv_version=2.7.2
ENV RBENV_VERSION=$rbenv_version

RUN rbenv install "${RBENV_VERSION}" && ruby --version

WORKDIR /home/app

COPY ruby-vips.gemspec Gemfile* /home/app/
COPY lib/vips/version.rb /home/app/lib/vips/
COPY . /home/app/

USER root

RUN chown -R app:appgroup /home/app
RUN chmod a+w+r /home/app

RUN ls -al  /home/app/

USER app

RUN gem update && gem install bundler:2.2.2 && bundle install
