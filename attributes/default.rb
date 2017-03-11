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

=begin
#<
The user to create to perform backups under. A group is also created under
this user name.
#>
=end
default['phpipam']['backup_user'] = 'backup'

#<> The home directory for backup configuration data and content.
default['phpipam']['backup_home'] = '/var/backup'

#<> The directory to hold backup data while performing backups.
default['phpipam']['backup_tmp_path'] = "#{default['phpipam']['backup_home']}/tmp"

=begin
#<
Enable logging backups to a log file. These logs go to the "log" directory
in the directory defined by `node['phpipam']['backup_home']`.
#>
=end
default['phpipam']['backup_enable_logfile'] = true

#<> Enable syslog logging. Logs get logged as `backup` under facility local0.
default['phpipam']['backup_enable_syslog'] = false

#<> The directory to store locally-kept backups.
default['phpipam']['backup_storage_path'] = "#{default['phpipam']['backup_home']}/storage"

#<> Enable S3 backup storage.
default['phpipam']['backup_s3_enabled'] = false

#<> The AWS Access Key ID for S3 backup storage.
default['phpipam']['backup_s3_access_key_id'] = ''

#<> The AWS secret access key for S3 backup storage.
default['phpipam']['backup_s3_secret_access_key'] = ''

#<> The AWS region your bucket is in.
default['phpipam']['backup_s3_region'] = ''

#<> The S3 bucket name for S3 storage.
default['phpipam']['backup_s3_bucket'] = ''

#<> The key (path) S3 backups will be stored in.
default['phpipam']['backup_s3_path'] = ''

#<> The number of days to keep local backups.
default['phpipam']['backup_keep_days_local'] = 7

#<> The number of days to keep S3 backups.
default['phpipam']['backup_keep_days_s3'] = 90

=begin
An array of notifiers. Notifiers follow the general syntax below, based off of
the syntax of the backup gem's [Notifiers resource][1]:

[1]: http://backup.github.io/backup/v4/notifiers/

        default['phpipam']['backup_notifiers'] = [
          {
            type: 'Mail',
            opts: {
              'from' => 'nobody@example.com',
              'to' => 'somebody@example.com',
            }
          }
        ]

Note that this cookbook by default notifies on success, warning, and failure.
=end
default['phpipam']['backup_notifiers'] = []

#<> The minute to run the backup job on (0-59).
default['phpipam']['backup_cron_minute'] = '00'

#<> The hour to run the backup job on (0-23).
default['phpipam']['backup_cron_hour'] =  '02'

#<> The weekday to run the backup job on (0-6, Sun-Sat, or * for every day).
default['phpipam']['backup_cron_weekday'] =  '*'

#<> A list of warning messages to ignore.
default['phpipam']['backup_ignore_warning_messages'] =  []
