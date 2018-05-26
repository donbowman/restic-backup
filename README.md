# restic-backup

This is a very simple container containing
[restic](https://github.com/restic/restic).

It exists to bolt to another container for purposes of backing up its
volumes.

I evaluated [stash](https://github.com/appscode/stash)
which would have been perhaps simpler, but it does
[not](https://github.com/appscode/stash/issues/126) support rest api
repositories.
