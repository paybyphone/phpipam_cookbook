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

Since this cookbook has not been released on Supermarket, you may need to take
extra steps to include it in your Chef server or other cookbooks with Berkshelf.

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
git clone https://github.com/paybyphone/phpipam_cookbook.git<Paste>
cd phpipam_cookbook
git checkout v9.9.99
berks install && berks upload
```
