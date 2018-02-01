FROM williamyeh/ansible:alpine3

COPY playbook /playbook
COPY runner.sh /usr/bin/runner

RUN apk add --update git openssh-client
RUN echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN chmod +x /usr/bin/runner

CMD ["/usr/bin/runner"]