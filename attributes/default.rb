#<> The host name to connect to for the PHPIPAM database.
default['phpipam']['db_host'] = 'localhost'

#<> The name of the PHPIPAM database.
default['phpipam']['db_name'] = 'phpipam'

#<> The user name for the PHPIPAM database.
default['phpipam']['db_user'] = 'phpipam'

#<> The password for the created PHPIPAM database.
default['phpipam']['db_password'] = 'phpipamadmin'

#<> The root password for the MySQL installation of the PHPIPAM database.
default['phpipam']['db_root_password'] = 'atotallyrandompassword'

#<> The document root, or where to install the PHPIPAM content.
default['phpipam']['docroot'] = '/var/www/html/phpipam'

=begin
#<
Keep the default virtualhost on Apache 2 installations.

You may want to set this to true on a system where PHPIPAM is not the only
site. Leaving this at the default will ensrue that the virtual host installed
is the default virtual host on the system.
#>
=end
default['phpipam']['apache2_keep_default_vhost'] = false

=begin
#<
The URI base to install PHPIPAM to. This will mean that the GUI and API will
be accessible through http(s)://example.com/phpipam/, for example, if this
was set to "/phpipam/".
#>
=end
default['phpipam']['uri_base'] = '/'

#<> The virtual host for the PHPIPAM site.
default['phpipam']['vhost_name'] = nil

#<> Any aliases that should be used to access PHPIPAM.
default['phpipam']['vhost_aliases'] = nil

=begin
#<
The version of IPAM to fetch the content for (and ultimately install).

Note that this technically is a ref string - hence it can be a version tag
(the intention), or a branch or commit. Using this to do the latter two is
not recommended as you will download a pre-release version of IPAM.
#>
=end
default['phpipam']['version'] = '1.2'

=begin
#<
The location to download the PHPIPAM content to. This is set to a directory
in /tmp to start with, and is overridden to the document root when running
the web content recipes.
#>
=end
default['phpipam']['download_path'] = '/tmp/phpipam'

=begin
#<
The owner of the downloaded content. This is modified to the system's web
user for web installations.
#>
=end
default['phpipam']['content_owner'] = 'root'

=begin
#<
The group of the downloaded content. This is modified to the system's web
group for web installations.
#>
=end
default['phpipam']['content_group'] = 'root'

#<> Install MySQL as part of the cookbook deployment.
default['phpipam']['install_mysql'] = true
