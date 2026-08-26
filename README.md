# Automated Server Backup Script (Linux Sysadmin Capstone)

A `bash` script that backs up a directory on a schedule, logs every run, and
sends an email alert if the backup fails — built while learning core Linux
system administration concepts from the ground up.

## What it does

- Archives and compresses `~/backup-project` into a timestamped `.tar.gz`
  file in `~/backups`, keeping backups outside the folder being backed up.
- Logs every run (start, success, or failure) with a timestamp to
  `~/backup-project/logs/cron.log`.
- Sends an email alert via `mail` (from the `mailutils` package) if the
  source directory is missing or the `tar` command fails.
- Runs automatically every 5 minutes via `cron`.

## Concepts covered

| Topic | Where it shows up |
|---|---|
| Filesystem hierarchy | Separating source (`~/backup-project`) from output (`~/backups`) to avoid `tar` archiving its own output |
| CLI commands | `tar`, `mkdir -p`, `date`, `hostname` |
| Permissions | `chmod +x backup.sh` so it can run as `./backup.sh` and via cron |
| Shell scripting | Variables, command substitution (`$(...)`), `if`/`else`, exit-code checks (`$?`) |
| Cron | Scheduled execution every 5 minutes, with stdout/stderr redirected to a log |
| Package management | `apt install mailutils` for the `mail` CLI used in alerting |
| Logs & monitoring | Custom application log (`cron.log`) plus system logs (`/var/log`, `journalctl`) used to verify cron actually fired |

## Setup

```bash
git clone <this-repo>
cd backup-project/scripts
chmod +x backup.sh
```

Edit `backup.sh` and set `EMAIL` to a real address. Install the mail utility
if not already present:

```bash
sudo apt update
sudo apt install mailutils -y
```

Run it manually to test:

```bash
./backup.sh
cat ../logs/cron.log
```

## Scheduling with cron

```bash
crontab -e
```

Add (adjusting the path to match your username/home directory):

```
*/5 * * * * /home/USER/backup-project/scripts/backup.sh >> /home/USER/backup-project/logs/cron.log 2>&1
```

## Notes / next steps

- `mail` will queue messages locally by default; a real SMTP relay
  (e.g. `ssmtp` or `msmtp`) is needed for actual email delivery.
- Recursive `chown`/`chmod` were intentionally *not* run on the whole repo —
  ownership/permissions in Linux are not inherited automatically; each file
  and directory carries its own.
