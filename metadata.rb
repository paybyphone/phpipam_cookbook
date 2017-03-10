name             'phpipam'
maintainer       'PayByPhone'
maintainer_email 'systems@paybyphone.com'
license          'Apache 2.0'
description      'Installs PHPIPAM (https://phpipam.net/)'
long_description 'Installs PHPIPAM (https://phpipam.net/)'

version          IO.read(File.expand_path('../CHANGELOG.md', __FILE__)).match(/^##\s+([-_.a-zA-Z0-9]+)$/)[1]
supports         'ubuntu', '= 14.04'

depends 'apache2',         '~> 3.2'
depends 'apt',             '~> 6.0'
depends 'build-essential', '~> 8.0'
depends 'database',        '~> 6.1'
depends 'mysql',           '~> 8.2'
depends 'php',             '~> 2.2'
depends 'poise-ruby',      '~> 2.2'

