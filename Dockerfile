FROM bconnect/gitlab-base

COPY playbook /playbook
COPY runner.sh /runner.sh

RUN chmod +x /runner.sh

CMD ["/runner.sh"]