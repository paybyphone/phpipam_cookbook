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
