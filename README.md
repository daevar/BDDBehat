Behat with Mink and Selenium 2 for Symfony 2
============================================

### Get composer ###

Latest version is always available via Composer website (http://getcomposer.org) or directly from your console:

```
curl -sS https://getcomposer.org/installer | php
```

### Install Symfony ###

```
php composer.phar create-project symfony/framework-standard-edition path/ 2.2.0
```

### Change files/folders owner to your www server ###

```
sudo chown www-data:www-data *
```

### Change permissions on Symfony cache/logs folders ###

(and any other files / dirs when necessary)

```
sudo setfacl -R -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs
sudo setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs
```

### Update .gitignore file ###

```
# Bootstrap
app/bootstrap*

# Symfony directories
vendor/*
*/logs/*
*/cache/*
web/uploads/*
web/bundles/*

# Configuration files
app/config/parameters.ini
app/config/parameters.yml

# Composer
composer.phar
composer.lock
```
