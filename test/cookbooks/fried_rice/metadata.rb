name             'fried_rice'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures fried_rice'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'ntp', '~> 1.4.0'
depends 'swap', '= 0.3.5'
depends 'marker', '~> 0.1.0'
depends 'windows'
depends 'awesome_cb'
