FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    puppet \
    ruby-dev \
    make \
    gcc

RUN gem install bundler

RUN puppet module install puppet-archive -v 3.2.1
RUN puppet module install puppetlabs-java -v 3.3.0
RUN puppet module install puppetlabs-postgresql -v 5.11.0
