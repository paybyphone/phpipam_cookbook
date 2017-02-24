# Description

This cookbook installs PHPIPAM on an Ubuntu 14.04 system.

It can be used to install a standalone app/db multi-role system on a single
system, or configured to install the application and database components on
separate servers.

NOTE: only specific versions of PHPIPAM are supported. We start with version
1.2, and will probably be adding 1.3 along with upgrade options eventually.

You can view all the PHPIPAM documentation at https://phpipam.net/.

# Requirements

## Platform:

* ubuntu (= 14.04)

## Cookbooks:

* apache2 (~> 3.2)
* mysql (~> 8.2)
* php (~> 2.2)
* database (~> 6.1)
* apt (~> 6.0)

# Attributes

* `node['phpipam']['db_host']` - The host name to connect to for the PHPIPAM database. Defaults to `localhost`.
* `node['phpipam']['db_name']` - The name of the PHPIPAM database. Defaults to `phpipam`.
* `node['phpipam']['db_user']` - The user name for the PHPIPAM database. Defaults to `phpipam`.
* `node['phpipam']['db_password']` - The password for the created PHPIPAM database. Defaults to `phpipamadmin`.
* `node['phpipam']['db_root_password']` - The root password for the MySQL installation of the PHPIPAM database. Defaults to `atotallyrandompassword`.
* `node['phpipam']['docroot']` - The document root, or where to install the PHPIPAM content. Defaults to `/var/www/html/phpipam`.
* `node['phpipam']['apache2_keep_default_vhost']` - Keep the default virtualhost on Apache 2 installations.

You may want to set this to true on a system where PHPIPAM is not the only
site. Leaving this at the default will ensrue that the virtual host installed
is the default virtual host on the system. Defaults to `false`.
* `node['phpipam']['uri_base']` - The URI base to install PHPIPAM to. This will mean that the GUI and API will
be accessible through http(s)://example.com/phpipam/, for example, if this
was set to "/phpipam/". Defaults to `/`.
* `node['phpipam']['vhost_name']` - The virtual host for the PHPIPAM site. Defaults to `nil`.
* `node['phpipam']['vhost_aliases']` - Any aliases that should be used to access PHPIPAM. Defaults to `nil`.
* `node['phpipam']['version']` - The version of IPAM to fetch the content for (and ultimately install).

Note that this technically is a ref string - hence it can be a version tag
(the intention), or a branch or commit. Using this to do the latter two is
not recommended as you will download a pre-release version of IPAM. Defaults to `1.2`.
* `node['phpipam']['download_path']` - The location to download the PHPIPAM content to. This is set to a directory
in /tmp to start with, and is overridden to the document root when running
the web content recipes. Defaults to `/tmp/phpipam`.
* `node['phpipam']['content_owner']` - The owner of the downloaded content. This is modified to the system's web
user for web installations. Defaults to `root`.
* `node['phpipam']['content_group']` - The group of the downloaded content. This is modified to the system's web
group for web installations. Defaults to `root`.
* `node['phpipam']['install_apache']` - Install the Apache2 web server as part of the cookbook deployment. Defaults to `true`.
* `node['phpipam']['install_mysql']` - Install MySQL as part of the cookbook deployment. Defaults to `true`.

# Recipes

* [phpipam::app_db](#phpipamapp_db) - This recipe installs the PHPIPAM database by creating the DB (root access required to the DB server) and importing the schema.
* [phpipam::app_site](#phpipamapp_site) - This recipe installs and configures the application and its content.

## phpipam::app_db

This recipe installs the PHPIPAM database by creating the DB (root access
required to the DB server) and importing the schema. It also installs MySQL,
if `node['phpipam']['install_mysql']` is set to true (the default).

## phpipam::app_site

This recipe installs and configures the application and its content. It also
installs Apache 2, if `node['phpipam']['install_apache']` is set to true (the
default).

# License and Maintainer

Maintainer:: PayByPhone (<systems@paybyphone.com>)

License:: Apache 2.0
