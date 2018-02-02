FROM mhart/alpine-node:9

ENV VERSION=v9.5.0 NPM_VERSION=5 YARN_VERSION=latest


RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo                                         && \
    \
    \
    echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates    && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible                && \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    pip install --upgrade pywinrm                  && \
    apk --update add sshpass openssh-client rsync  && \
    \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts


ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN apk --update add ca-certificates
RUN echo "@php https://php.codecasts.rocks/v3.7/php-7.1" >> /etc/apk/repositories
RUN apk add --update php7@php
RUN apk add --update php7-cli@php
RUN apk add --update php7-curl@php
RUN apk add --update php7-openssl@php
RUN apk add --update php7-json@php
RUN apk add --update php7-phar@php
RUN apk add --update php7-dom@php

COPY playbook /playbook
COPY runner.sh /runner.sh

RUN apk add --update git openssh-client
RUN echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN chmod +x /runner.sh

CMD ["/runner.sh"]