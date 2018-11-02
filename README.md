# JoomlaDeception

Development Edition

`vagrant init thealex7r/joomladeception-dev; vagrant up`

## Packaging:

Blackbox

`vagrant package --output jdeception-blackbox.box --vagrantfile Blackbox`

Development

`vagrant package --output jdeception-dev.box --vagrantfile Dev`

## BuildRun codeception tests

Just run `acceptence_test`

##### Codeception documentation

Joomla! CMS example can be found @ codeception.com/for/joomla

To use those command you should be in `cd /var/www/composer`

`vendor/bin/codecept` can be simplified to `codecept`

So for generating example test file use

`codecept generate:cest acceptance AdminLoginCest`