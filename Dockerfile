FROM ubuntu:14.04
MAINTAINER Ascensio System SIA <support@onlyoffice.com>

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d && \
    echo "deb http://download.onlyoffice.com/repo/debian squeeze main" >>  /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D9D0BF019CC8AC0D && \
    DEBIAN_FRONTEND=noninteractive  && \
    locale-gen en_US.UTF-8 && \
    apt-get update && \
    apt-get install -yq onlyoffice && \
    rm -rf /var/lib/apt/lists/*

ADD run-onlyoffice.sh /run-onlyoffice.sh
RUN chmod 755 /*.sh

VOLUME ["/var/log/onlyoffice"]

EXPOSE 80
EXPOSE 443

CMD bash -C '/run-onlyoffice.sh';'bash'
