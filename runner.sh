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

echo "Starting ansible script";

if ! [ -f "/key.priv" ]
then
  mkdir /root/.ssh
  echo "$SSH_KEY" > /root/.ssh/id_rsa
  chmod 700 /root/.ssh/id_rsa
  chown root:root /root/.ssh/id_rsa
fi

if [ -z "$DRUPAL_DOCROOT" ]
then
  export DRUPAL_DOCROOT="docroot";
fi

if [ -z "$EXLUDE_RSYNC" ]
then
  export EXCLUDE_RSYNC="${DRUPAL_DOCROOT}/sites/default/settings.php,${DRUPAL_DOCROOT}/sites/default/files"
fi

entries=$(echo $EXCLUDE_RSYNC | tr "," "\n")

for entry in $entries
do
    echo $entry >> /excludes.txt
done

echo "Rsync ignore:"
cat /excludes

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

if [ -z ${CUSTOM_PLAYBOOK+x} ]
then
  echo "Using playbook: ${PLAYBOOK}"
else
  echo "SET CUSTOM PLAYBOOK"
  export PLAYBOOK="${CI_PROJECT_DIR}/${CUSTOM_PLAYBOOK}"
fi

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook $PLAYBOOK -u $DEPLOY_USER --inventory /inventory
