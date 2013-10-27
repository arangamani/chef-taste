name             'noodles'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures noodles'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'mysql', '~> 3.0.12'
depends 'apache2', '~> 1.7.0'
depends 'windows'
