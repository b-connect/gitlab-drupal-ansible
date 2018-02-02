# Variables

```yml
dev_deploy:
  image: bconnect/gitlab-drupal-ansible
  when: manual
  stage: deploy
  environment:
    name: dev
    url: http://my.dev.example.com
  variables:
    DEPLOY_USER: dev
    DEPLOY_HOST: dev.b-connect.eu
    DRUPAL_ACCOUNT_NAME: admin
    DRUPAL_ACCOUNT_PASS: admin
    DRUPAL_PROFILE: standard
    DOCKSAL_ENV_FILE: ".docksal/docksal-local.env"
    DRUPAL_SITE_INSTALL_FLAGS: " --config-dir=../config/sync"
    COMPOSER_INSTALL_FLAGS: "--optimize-autoloader --quiet"
  script:
    - /usr/bin/runner
```


# Path

```
/home/{{ ansible_user }}/ansible/{{ CI_ENVIRONMENT_SLUG }}/{{ CI_PROJECT_NAMESPACE}}/{{ CI_PROJECT_NAME }}
```