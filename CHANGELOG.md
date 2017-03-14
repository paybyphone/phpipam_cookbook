## 0.2.2

 * `uri_base` now has its trailing slash, if present, trimmed on non-default
   setups. Docroot path is also normalized to ensure that trailing slashes are
   present everywhere in the apache config. This is to support proxies where
   the bare word URI (like `/phpipam`) is desired and the user does not want to
   set up an extra redirect.

## 0.2.1

This update moves S3 storage to the top of the storage order in the backups
recipe. This ensures that if S3 is included, that backups are properly moved to
local storage versus copied, avoiding extra I/O  and storage issues, in addition
to keeping unnecessary warnings from happening.

## 0.2.0

**NOTE:** To avoid bugs and errors, do not use any 0.1.x version of this
cookbook - there may be certain features that were not usable as intended.

Fixes since 0.1.8:

 * Fixed backup cron job, path to job now uses an absolute path. This ensures
   that the job runs.
 * Ensure that the default `/var/run/mysql` symlink that we create does not get
   blown away on subsequent Chef runs other than the first one.
 * Change the backup user to `ipambackup`, and the default home directory to
   `/var/ipambackup`. This ensures that the installed backup job does not
   interfere with any distro-level backup processes that use the default
   `backup` user and `/var/backup` directory.

## 0.1.8

Added the `backup_ignore_warning_messages` node attribute which allows you
to configure warning messages to ignore.

Also fixed a small indentation issue on the backup model.

## 0.1.7

Fixed the backup model template so that it doesn't render the default
`on_success`, `on_warning`, or `on_failure` options if user-defined ones are
given.

## 0.1.6

This update adds backup support - installed using the ruby backup gem.
Backup options can be set up to use S3 in addition to local storage
(mandatory) with configurable thresholds for each. You can also
configure a custom number of notifiers.

## 0.1.5
    
The `uri_base` option is back. Defining a `uri_base` other than `/` does the following:

 * Sets `BASE` and `RewriteBase` in `config.php` and `.htaccess` respectively to
   whatever you define
 * Adds an `Alias` directive in Apache for the correct URI path (in case
   you are not using this to reverse proxy)

Also explicitly forced the MPM in use to prefork.

## 0.1.4

Added `build-essential` to the cookbook chain, as building the `mysql2` gem
requires `make`, which may not be available on minimal systems.

## 0.1.3

Added version automation off of `metadata.rb`. The cookbook is now versioned off
of this `CHANGELOG.md` file. To release, you need to switch to the release tag
that you want to release or upload, and then do your needful (example: `berks
install && berks upload`, or cookbook release if we so add it later).

Using versions prior to this one are not recommended as they will be stuck at
version `0.1.0`.

## 0.1.2

Bump a version to lock in documentation updates.

## 0.1.1

This release should be used over `0.1.0` as there were some bugs that make using
it unusable.

 * Removed the `uri_base` attribute as it was never usable and I've decided to
   not implement it.
 * Remove the `install_apache` option as the Apache virtual host needs to be
   dropped in for this to be fully functional. Coexistence with other virtual
   hosts on the same server is still possible if `apache2_keep_default_vhost` is
   set.

## 0.1.0

Initial release.
