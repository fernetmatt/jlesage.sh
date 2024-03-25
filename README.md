# jlesage.sh
Convenience script to run [jlesage](https://github.com/jlesage) graphical container applications in the default browser

# Description

The script lets the user automatically list and start a jlesage's graphical container application
with the default browser.

# Install

Edit the script and set the needed envs:

```bash
#!/bin/bash
# Convenience script for starting jlesage container apps

HOME_DIR="/home/johndoe"
MEDIA_DIR="/run/media/johndoe"

[...]
```

# Usage

## List all apps

```bash
$ jlesage.sh
Commands: stopall, ps, ls, {app_name}
```

## List apps

```bash
$ jlesage.sh ls
```

## Start an app

```bash
$ jlesage.sh freefilesync
```

## List running container

```bash
$ jlesage.sh ps
```

## Stop all

```bash
$ jlesage.sh stopall
```