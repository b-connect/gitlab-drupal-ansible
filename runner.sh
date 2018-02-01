#!/bin/sh
if [ -z "$DEPLOY_HOST" ]; then
    echo "Need to set DEPLOY_HOST"
    exit 1
fi
if [ -z "$SSH_KEY" ]; then
    echo "Need to set SSH_KEY"
    exit 1
fi

echo "Starting ansible script";

echo "-- ADD SSH KEY --";

mkdir /root/.ssh
echo "$SSH_KEY" > /root/.ssh/id_rsa
chmod 700 /root/.ssh/id_rsa

ansible --version

chmod root:root /root/.ssh -R

echo ${DEPLOY_HOST} > /inventory

ansible-playbook /playbook/bootstrap.yml -u dev --inventory /inventory