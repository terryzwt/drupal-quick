ARG DRUPAL_VERSION
FROM drupal:${DRUPAL_VERSION}-apache
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN apt-get update -y && apt-get install -y vim fish sqlite3 zip unzip wget git default-mysql-client iputils-ping && \
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /usr/local/etc/php/php.ini && \
    cd /opt/drupal && \
    rm -rf vendor && rm composer.lock && \
    composer install && \
    #mkdir -p ~/.config/fish/completions/ && ln -s ~/.console/drupal.fish ~/.config/fish/completions/drupal.fish && \
    chown www-data:www-data /opt/drupal && \
    ## install drupal module
    sed -i 's/"minimum-stability": "stable"/"minimum-stability": "dev"/g' composer.json && \
    composer require drush/drush drupal/admin_toolbar drupal/devel drupal/devel_php davyin/drupal_settings && \
    cp vendor/davyin/drupal_settings/assets/* web/sites/default/ && \
    cp web/sites/default/default.settings.php web/sites/default/settings.php && \
    chmod 777 web/sites/default/settings.php && \
    composer drupal:scaffold -q
USER www-data
#VOLUME /data
USER root

ENTRYPOINT ["docker-entrypoint"]
# https://github.com/docker-library/php/blob/master/8.1-rc/buster/apache/Dockerfile
STOPSIGNAL SIGWINCH
COPY docker-entrypoint /usr/local/bin/

CMD ["apache2-foreground"]
