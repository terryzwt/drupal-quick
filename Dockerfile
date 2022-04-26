FROM drupal:9-apache
ENV DRUSH_LAUCHER 0.10.1
ENV DRUSH_LAUNCHER_FALLBACK /usr/local/bin/drush
ENV COMPOSER_MEMORY_LIMIT -1
RUN apt-get update -y && apt-get install -y vim fish sqlite3 zip unzip wget git default-mysql-client iputils-ping && \
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /usr/local/etc/php/php.ini && \
    mkdir /data && \
    chown -R www-data:www-data /data && \
    #chsh -s /usr/bin/fish && \
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    ###### install drush laucher ######
    wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/$DRUSH_LAUCHER/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    # Install console.
    curl https://drupalconsole.com/installer -L -o drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal && \
    composer require drupal/console drush/drush && \
    composer update && \
    #mkdir -p ~/.config/fish/completions/ && ln -s ~/.console/drupal.fish ~/.config/fish/completions/drupal.fish && \
    # drupal init && \
    ## ensure the durpal console can run as www-data
    chown www-data:www-data /opt/drupal && \
    ## install drupal module
    composer require drupal/admin_toolbar
USER www-data
#VOLUME /data
RUN drush site-install -y --account-pass=admin --db-url=sqlite:///tmp/.drupal.sqlite && \
    drush cr && \
    drush pm:enable -y admin_toolbar_tools admin_toolbar_search admin_toolbar_links_access_filter
USER root

ENTRYPOINT ["docker-entrypoint"]
# https://github.com/docker-library/php/blob/master/8.1-rc/buster/apache/Dockerfile
STOPSIGNAL SIGWINCH
COPY docker-entrypoint /usr/local/bin/

CMD ["apache2-foreground"]
