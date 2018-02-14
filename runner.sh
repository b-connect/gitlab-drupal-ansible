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
    export PLAYBOOK="/playbook/start.yml"
fi

ssh-keyscan ${DEPLOY_HOST}  2> /dev/null

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
  export EXCLUDE_RSYNC="${DRUPAL_DOCROOT}/sites/default/settings.php,${DRUPAL_DOCROOT}/sites/default/files, .docksal"
fi

entries=$(echo $EXCLUDE_RSYNC | tr "," "\n")

for entry in $entries
do
    echo $entry >> /excludes.txt
done

chmod 700 /key.priv
chown root:root /key.priv

echo "Checkout: ${CI_REPOSITORY_URL}"

echo ${DEPLOY_HOST} > /inventory

if [ -z "$DEPLOY_ACTION" ]
then
  export DEPLOY_ACTION="start"
fi

if [ "$DEPLOY_ACTION" = "stop" ]
then
  export PLAYBOOK="/playbook/stop.yml"
fi

ansible-playbook $PLAYBOOK -u $DEPLOY_USER --inventory /inventory --private-key /key.priv
