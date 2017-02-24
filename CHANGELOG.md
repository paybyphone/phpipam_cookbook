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
