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
After running the command above, Behat will generate our main Feature Context and base folder structure:
```
+d features - place your *.feature files here
+d features/bootstrap - place bootstrap scripts and static files here
+f features/bootstrap/FeatureContext.php - place your feature related code here
```
Now, having everything in place, we can start with our first Behat scenario.

### Start testing with Behat ###

Create file features/index.feature with the following code:

```
Feature: Default page test
    In order to test with Behat
    As a web developer
    I need to create and run tests

Scenario: Test link to demo
    Given I am on the homepage
    When I press "Run The Demo"
    Then the response status code should be 200
    And I should be on "/demo/"
```
When you run it, you will see that all the steps are undefined:
```
1 scenario (1 undefined)
4 steps (4 undefined)
```
It's because we're using BehatContext in our FeatureContext, while for testing websites we need a browser - Mink to the rescue.

### Configure Behat to use Mink ###

Add behat.yml file to your application folder with the following details:

```
default:
    extensions:
        Behat\MinkExtension\Extension:
            default_session:    symfony2
            javascript_session: ~
            base_url:           http://bdd-behat.local
        Behat\Symfony2Extension\Extension:
            kernel:
                env:     test
                debug:   true
            mink_driver: true
    formatter:
        name:       pretty
        parameters:
            decorated:           true
            verbose:             false
            time:                true
            language:            en
            output_path:         null
            multiline_arguments: true
```

In place of base_url option put full url to your symfony application, i. e. http://localhost/symfony/web/app_dev.php.
To have nicer local address, if you're using Apache as your web server, you may want to configure new virtual host.

Once behat configuration is in place, try running bin/behat again, this time you should get:

```
Button with id|name|title|alt|value "Run The Demo" not found.

1 scenario (1 failed)
4 steps (1 passed, 2 skipped, 1 failed)
```

My bad, "Run The Demo" is not a button, it's a link. All you need to do is to change "press" to "follow" in your index.feature and run behat again.

```
1 scenario (1 passed)
4 steps (4 passed)
```

We already have a proper BDD environment with PHPUnit, Behat and Mink configured, but we still can't test javascript on our pages.
That's why we also need Selenium.

### Add Selenium to Behat and Mink ###

You can download the latest Selenium release from this link - http://code.google.com/p/selenium/downloads/list.
What you're looking for is a latest version of standalone selenium server, i. e. selenium-server-standalone-2.31.0.jar.

Make the downloaded file executable
```
chmod 777 selenium-server-standalone-2.31.0.jar
```

Now you can start a hub:
```
java -jar selenium-server-standalone-2.31.0.jar -role hub
```

And also a selenium node, configured as firefox browser:
```
java -jar selenium-server-standalone-2.31.0.jar -role node -hub http://localhost:4444/grid/register -browser browserName=firefox,version=12,maxInstances=5,platform=LINUX
```

If everything is working correctly, your selenium is ready for tests, and you should be able to see all active sessions here - http://localhost:4444/grid/console.

By default, Behat will try to run all tests tagged with @javascript with whatever is configured as javascript_session in behat.yml.

Then it's time to modify the config:
```
default:
    extensions:
        Behat\MinkExtension\Extension:
            default_session:    symfony2
            javascript_session: selenium2
            base_url:           http://bdd-behat.local
            browser_name:       'firefox'
            selenium2:
                capabilities: { browserName: 'firefox', version: '12', platform: 'ANY', javascriptEnabled: true }
        Behat\Symfony2Extension\Extension:
            kernel:
                env:     behat
                debug:   true
            mink_driver: true
    formatter:
        name:       pretty
        parameters:
            decorated:           true
            verbose:             false
            time:                true
            language:            en
            output_path:         null
            multiline_arguments: true
```

Please note that the browser and version in Behat config must be the same as the one we're running on Selenium, otherwise it won't work.

When you run bin/behat again, the result should be similar to this:
```
Status code is not supported by Behat\Mink\Driver\Selenium2Driver

1 scenario (1 failed)
4 steps (2 passed, 1 skipped, 1 failed)
```

Sadly, we can't test response code with Selenium; once we comment out this line tests will be working again.
