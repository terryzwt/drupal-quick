FROM drupal:8-apache
ENV DRUSH_VERSION 8.3.0
ENV DRUSH_LAUCHER 0.6.0
ENV DRUSH_LAUNCHER_FALLBACK=/usr/local/bin/drush8
RUN apt-get update -y && apt-get install vim fish sqlite3 -y wget && \
    chsh -s /usr/bin/fish && \
    php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    ###### install drush ######
    curl -fsSL -o /usr/local/bin/drush8 https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar | sh && \
    chmod +x /usr/local/bin/drush8 && \
    drush8 core-status && \
    ###### install drush laucher ######
    wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/$DRUSH_LAUCHER/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    # Install console.
    curl https://drupalconsole.com/installer -L -o drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal && \
    #composer require drupal/console && \
    mkdir -p ~/.config/fish/completions/ && ln -s ~/.console/drupal.fish ~/.config/fish/completions/drupal.fish && \
    ##drupal init --override && \
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /usr/local/etc/php/php.ini
USER www-data
RUN drush site-install -y --account-pass=admin --db-url=sqlite://sites/default/files/.ht.sqlite
USER root
#RUN fish
