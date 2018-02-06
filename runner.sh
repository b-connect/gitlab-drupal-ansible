#!/bin/sh
if [ -z "$DEPLOY_HOST" ]; then
    echo "Need to set DEPLOY_HOST"
    exit 1
fi
if [ -z "$SSH_KEY" ]; then
    echo "Need to set SSH_KEY"
    exit 1
fi
if [ -z "$DEPLOY_USER" ]; then
    echo "Need to set DEPLOY_USER"
    exit 1
fi
if [ -z "$PLAYBOOK" ]; then
    export PLAYBOOK="/playbook/bootstrap.yml"
fi

ssh-keyscan ${DEPLOY_HOST}

echo "Starting ansible script";

echo "-- ADD SSH KEY --";

if ! [ -f "/key.priv" ]
then
  echo "$SSH_KEY" > /key.priv
fi

if [ -z "$DRUPAL_DOCROOT" ]
then
  export DRUPAL_DOCROOT="docroot";
fi

if [ -z "$EXLUDE_RSYNC" ]
then
  touch /excludes.txt
  export EXCLUDE_RSYNC="${DRUPAL_DOCROOT}/sites/default/settings.php, ${DRUPAL_DOCROOT}/sites/default/files"
  echo $EXCLUDE_RSYNC | sed -n 1'p' | tr ',' '\n' | while read word; do
    echo >> /excludes.txt
  done
fi

chmod 700 /key.priv
chown root:root /key.priv

echo "Checkout: ${CI_REPOSITORY_URL}"

echo ${DEPLOY_HOST} > /inventory

ansible-playbook $PLAYBOOK -u $DEPLOY_USER --inventory /inventory --private-key /key.priv
