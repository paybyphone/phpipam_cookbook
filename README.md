# Description

This cookbook installs PHPIPAM on an Ubuntu 14.04 system.

It can be used to install a standalone app/db multi-role system on a single
system, or configured to install the application and database components on
separate servers. It also has a recipe to install a job to backup the PHPIPAM
database (see the below section).

NOTE: only specific versions of PHPIPAM are supported. We start with version
1.2, and will probably be adding 1.3 along with upgrade options eventually.

You can view all the PHPIPAM documentation at https://phpipam.net/.

## About Backups

Backups are installed and performed using the [Ruby backup gem][1] if the
`phpipam::backup` recipe is included in the run list. By default, backups are
made locally and kept for 7 days, but this is configurable. S3 options are also
available. See the attributes and recipe sections for more details.

[1]: https://github.com/backup/backup

### Using Custom Notifiers for Backups

Notifiers can be configured for backups. For the exact syntax that you want to
use, see the details for the backup gem's [Notifier resource][2]. The notifiers
are supplied to the `node['phpipam']['backup_notifiers']` attribute, as an array
of hashes, with the `type:` key specifying the notifier type, and the rest of
the options specified as a hash to the `opts:` key, like below. Note that by
default, notifiers are configured to notify on success, warning, and failure.

[2]: http://backup.github.io/backup/v4/notifiers/

```
node.default['phpipam']['backup_notifiers'] = [
  {
    type: 'Mail',
    opts: {
      'from' => 'nobody@example.com',
      'to' => 'somebody@example.com',
    }
  }
]
```

### Ignoring Certain Backup Warnings

You can also ignore certain backup warnings via
`node['pbpipam']['backup_ignore_warning_messages']`:

```
node.default['pbpipam']['backup_ignore_warning_messages'] = [
  /fog: the specified s3 bucket name\(.*\) contains a/,
  'some-exact-string-match'
]
```

**NOTE:** If you want to use literals more complex than a string (like the regex
above), you need to specify your node attributes with Ruby - either use a
wrapper cookbook or a process that passes your attributes in Ruby. Try to avoid
JSON or YAML. **Note that this behaviour is not necessarily Chef compliant** -
for example, your `Regexp` literals will show up as strings when saved to the
Chef server. You have been warned!

## About Releases

This cookbook has not been released on Supermarket. This may change in the
future, but until then, you need to take extra steps to include it in your
Chef server or other cookbooks with Berkshelf.

### Including in Berkshelf

Releases are tagged, so you can include the cookbook at a certain release simple
enough. Below is an example `Berksfile`. Change the release version below to
the release that you want.

```
source "https://supermarket.chef.io"

cookbook 'phpipam', git: 'https://github.com/paybyphone/phpipam_cookbook.git', tag: 'v9.9.99'

metadata
```

### Adding Direct to Chef Server

To add this cookbook to a Chef server directly, clone the repository, check out
the release you want, and then run the Berkshelf commands to add it:

```
git clone https://github.com/paybyphone/phpipam_cookbook.git
cd phpipam_cookbook
git checkout v9.9.99
berks install && berks upload
```

# Requirements

## Platform:

* ubuntu (= 14.04)

## Cookbooks:

* apache2 (~> 3.2)
* apt (~> 6.0)
* build-essential (~> 8.0)
* database (~> 6.1)
* mysql (~> 8.2)
* php (~> 2.2)
* poise-ruby (~> 2.2)

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
* `node['phpipam']['install_mysql']` - Install MySQL as part of the cookbook deployment. Defaults to `true`.
* `node['phpipam']['backup_user']` - The user to create to perform backups under. A group is also created under
this user name. Defaults to `ipambackup`.
* `node['phpipam']['backup_home']` - The home directory for backup configuration data and content. Defaults to `/var/ipambackup`.
* `node['phpipam']['backup_tmp_path']` - The directory to hold backup data while performing backups. Defaults to `#{default['phpipam']['backup_home']}/tmp`.
* `node['phpipam']['backup_enable_logfile']` - Enable logging backups to a log file. These logs go to the "log" directory
in the directory defined by `node['phpipam']['backup_home']`. Defaults to `true`.
* `node['phpipam']['backup_enable_syslog']` - Enable syslog logging. Logs get logged as `backup` under facility local0. Defaults to `false`.
* `node['phpipam']['backup_storage_path']` - The directory to store locally-kept backups. Defaults to `#{default['phpipam']['backup_home']}/storage`.
* `node['phpipam']['backup_s3_enabled']` - Enable S3 backup storage. Defaults to `false`.
* `node['phpipam']['backup_s3_access_key_id']` - The AWS Access Key ID for S3 backup storage. Defaults to ``.
* `node['phpipam']['backup_s3_secret_access_key']` - The AWS secret access key for S3 backup storage. Defaults to ``.
* `node['phpipam']['backup_s3_region']` - The AWS region your bucket is in. Defaults to ``.
* `node['phpipam']['backup_s3_bucket']` - The S3 bucket name for S3 storage. Defaults to ``.
* `node['phpipam']['backup_s3_path']` - The key (path) S3 backups will be stored in. Defaults to ``.
* `node['phpipam']['backup_keep_days_local']` - The number of days to keep local backups. Defaults to `7`.
* `node['phpipam']['backup_keep_days_s3']` - The number of days to keep S3 backups. Defaults to `90`.
* `node['phpipam']['backup_notifiers']` -  Defaults to `[ ... ]`.
* `node['phpipam']['backup_cron_minute']` - The minute to run the backup job on (0-59). Defaults to `00`.
* `node['phpipam']['backup_cron_hour']` - The hour to run the backup job on (0-23). Defaults to `02`.
* `node['phpipam']['backup_cron_weekday']` - The weekday to run the backup job on (0-6, Sun-Sat, or * for every day). Defaults to `*`.
* `node['phpipam']['backup_ignore_warning_messages']` - A list of warning messages to ignore. Defaults to `[ ... ]`.

# Recipes

* [phpipam::app_db](#phpipamapp_db) - This recipe installs the PHPIPAM database by creating the DB (root access required to the DB server) and importing the schema.
* [phpipam::app_site](#phpipamapp_site) - This recipe installs and configures the application and its content.
* [phpipam::backup](#phpipambackup) - This recipe installs backups using the [Ruby backup gem][1].

## phpipam::app_db

This recipe installs the PHPIPAM database by creating the DB (root access
required to the DB server) and importing the schema. It also installs MySQL,
if `node['phpipam']['install_mysql']` is set to true (the default).

## phpipam::app_site

This recipe installs and configures the application and its content. It also
installs Apache 2, if not installed already.

## phpipam::backup

This recipe installs backups using the [Ruby backup gem][1]. Options are
available in node attributes for sending the backups to S3, syslog logging, and
specifying notifier configuration through the
`node['phpipam']['backup_notifiers']` array. See the description section for
examples.

[1]: https://github.com/backup/backup


# License and Maintainer

Maintainer:: PayByPhone (<systems@paybyphone.com>)

License:: Apache 2.0
