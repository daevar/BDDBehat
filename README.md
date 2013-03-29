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

We want to exclude files and folders that won't be modified by us.

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

### Install PHPUnit ###

At this point we're ready to run first tests. Let's start with installation of PHPUnit. You can check if you already have PHPUnit installed by running:

```
phpunit --version
```
If PHPUnit is already installed, you should see information about version:
```
PHPUnit 3.6.10 by Sebastian Bergmann.
```
Otherwise, use the command below to install it:
```
sudo apt-get install phpunit
```
And we're ready to run first Unit test, written for default Symfony controller:

```
phpunit -c app
```

### Install Behat, Mink, Selenium 2 and Symfony 2 extensions ###

Simply modify your composer.json file to add new packages (doctrine data fixtures and fixture bundle are optional):
```
"require": {
    ...,
    "doctrine/data-fixtures": "dev-master",
    "doctrine/doctrine-fixtures-bundle": "dev-master",
    ...,
    "behat/behat": "2.4.*@stable",
    "behat/mink-extension": "*",
    "behat/mink-goutte-driver": "*",
    "behat/mink-selenium2-driver": "*",
    "behat/mink-browserkit-driver":  "*",
    "behat/symfony2-extension": "*",
},
```
And run composer with update option:
```
php composer.phar update
```

### Initialise Behat ###

We're ready to start playing with Behat.

First, initialisation:

```
bin/behat --init
```
After running the command above, Behat will generate our main Feature Context base folder structure:
```
+d features - place your *.feature files here
+d features/bootstrap - place bootstrap scripts and static files here
+f features/bootstrap/FeatureContext.php - place your feature related code here
```
Now, having everything in place, we can start with our first Behat scenario.
