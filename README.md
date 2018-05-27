# restic-backup

This is a very simple container containing
[restic](https://github.com/restic/restic).

It exists to bolt to another container for purposes of backing up its
volumes.

I evaluated [stash](https://github.com/appscode/stash)
which would have been perhaps simpler, but it does
[not](https://github.com/appscode/stash/issues/126) support rest api
repositories.

## Configuration

There are four environment variables:

* RESTIC_INTERVAL --> How often (in hours) to backup, default 4
* RESTIC_BACKUP_DIR --> What directory to backup from
* RESTIC_HOSTNAME --> Override the hostname (since the container name is not right)
* RESTIC_REPOSITORY --> The URL/backup to send to (e.g. rest:https://user:pass@host/user

The container can be run with a single parameter 'auto', in which
case it will start cron and run every RESTIC_INTERVAL hours. Or, you
can run it with parameters directly to restic (e.g. ```docker run --rm -it IMAGE snapshots```)

## Intended use

The intended use is to backup a Kubernetes pod. Imagine a pod:

```
apiVersion: v1
kind: Pod
metadata:
  name: MyThing
spec:
  restartPolicy: Never
  volumes:
  - name: backup
    emptyDir: {}

  containers:
  - name: MyThing
    image: MyImage
    volumeMounts:
    - name: backup
      mountPath: /var/backups/dir

  - name: backup
    image: cr.agilicus.com/corp-tools/restic-backup
    environment:
    - RESTIC_PASSWORD: MYPASS
      RESTIC_REPOSITORY: https://USER:MYPASS@URL/USER
      RESTIC_INTERVAL: 4
      RESTIC_HOSTNAME: MyThing
    volumeMounts:
    - name: backup
      mountPath: /var/backups/dir
```

In this case, we will take a snapshot every 4 hours of /var/backups/dir,
which is shared between MyThing and the backup container.

