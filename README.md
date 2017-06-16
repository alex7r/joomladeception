# JoomlaDeception
Packaging command:

`vagrant package --output BOXNAME.box --vagrantfile Basefile`

## BuildRun codeception tests
Just run `acceptence_test`

##### Codeception documentation

Joomla! CMS example can be found @ codeception.com/for/joomla

To use those command you should be in `cd /var/www/composer`

`vendor/bin/codecept` can be simplified to `codecept`

So for generating example test file use

`codecept generate:cest acceptance AdminLoginCest`