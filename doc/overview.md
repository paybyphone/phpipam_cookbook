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
`node['pbpipam']['backup_ignore_warnings']:

```
node.default['pbpipam']['backup_ignore_warnings'] = [
  /fog: the specified s3 bucket name\(.*\) contains a/,
  'some-exact-string-match'
]
```

**NOTE:** If you want to use literals more complex than a string (like the regex
above), you need to specify your node attributes with Ruby - either use a
wrapper cookbook or a process that passes your attributes in Ruby. Try to avoid
JSON or YAML.
