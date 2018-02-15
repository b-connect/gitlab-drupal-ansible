FROM bconnect/gitlab-base:latest

COPY playbook /playbook
COPY runner.sh /runner.sh

RUN chmod +x /runner.sh

CMD ["/runner.sh"]