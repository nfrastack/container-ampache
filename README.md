# nfrastack/container-ampache

## About

This repository will build a container image for running Ampache — a web based audio file manager and media server.

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents

* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
    * [Database](#database)
    * [Catalog / Watcher](#catalog--watcher)
    * [Scheduler / Cron](#scheduler--cron)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Builds are available on the Github Container Registry and Docker Hub:

```text
ghcr.io/nfrastack/container-ampache:(image_tag)
docker.io/nfrastack/ampache:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>-<optional phpversion>`

Example:

`docker.io/nfrastack/ampache:latest`

* `latest` will be the most recent commit on the latest PHP version
* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - these are the safest

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See [examples/compose.yml](examples/compose.yml) for a working stack you can tailor to your environment.
* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set [environment variables](#environment-variables) to control container behavior.

**The first boot can take 1-5 minutes depending on your CPU as the schema is created and assets are warmed.**

### Persistent Storage

| Directory        | Description                                           |
| ---------------- | ----------------------------------------------------- |
| `/config`        | Configuration Files                                   |
| `/cache`         | (Optional) Persistent Cache                           |
| `/data/art`      | (Optional) Artist Art                                 |
| `/data/metadata` | (Optional) Metadata                                   |
| `/logs`          | Ampache, Nginx and PHP log files                      |
| `/www/ampache`   | (Optional) Expose the Ampache source tree to the host |
| `/media`         | Your media                                            |

## Configuration

### Environment Variables

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

#### Base Images used

| Image                                                                 | Description         |
| --------------------------------------------------------------------- | ------------------- |
| [OS Base](https://github.com/nfrastack/container-base/)               | Base image          |
| [Nginx](https://github.com/nfrastack/container-nginx/)                | Nginx webserver     |
| [Nginx PHP-FPM](https://github.com/nfrastack/container-nginx-php-fpm) | PHP-FPM interpreter |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Parameter         | Description                                                                               | Default                       | `_FILE` |
| ----------------- | ----------------------------------------------------------------------------------------- | ----------------------------- | ------- |
| `CONFIG_PATH`     | Path where Ampache config is stored                                                       | `/config/`                    | x       |
| `CONFIG_FILE`     | Config filename                                                                           | `ampache.cfg.php`             | x       |
| `CACHE_PATH`      | Cache Path                                                                                | `/cache/`                     |         |
| `ARTIST_ART_PATH` | Artist Artwork Path (optional)                                                                      |                               |
| `METADATA_PATH`   | Metadata Path (optional)                                                                            |                               |
| `SETUP_TYPE`      | `AUTO` writes config, runs migrations, creates the bootstrap admin. `MANUAL` does nothing | `AUTO`                        |         |
| `ADMIN_USER`      | Username for the bootstrap admin user (created on a fresh DB only)                        | `admin` (example)             | x       |
| `ADMIN_PASS`      | Password of the bootstrap admin                                                           | (required when bootstrapping) | x       |
| `ADMIN_NAME`      | Display name for the bootstrap admin (optional)                                           | `Admin`                       | x       |
| `ADMIN_EMAIL`     | Email of the bootstrap admin user (optional)                                              | `admin@example.com`           | x       |


#### Database

| Parameter | Description                                       | Default | `_FILE` |
| --------- | ------------------------------------------------- | ------- | ------- |
| `DB_HOST` | Hostname or container name of the database server |         | x       |
| `DB_PORT` | Database port                                     | `3306`  | x       |
| `DB_NAME` | Database name                                     |         | x       |
| `DB_USER` | Database username                                 |         | x       |
| `DB_PASS` | Database password                                 |         | x       |

#### Catalog / Watcher

| Parameter                    | Description                                                        | Default   |
| ---------------------------- | ------------------------------------------------------------------ | --------- |
| `ENABLE_CATALOG_WATCH`       | Run inotify-based catalog watcher                                  | `TRUE`    |
| `CATALOG_<NAME>_PATH`        | One or more environment variables pointing to directories to watch |           |
| `CATALOG_WATCH_EXTENSIONS`   | File extensions to watch (comma separated)                         | See Below |
| `CATALOG_WATCH_ENABLE_CLEAN` | Use clean variant when running updates                             | `TRUE`    |

> Defaults are `mp3,mpc,m4p,m4a,aac,ogg,oga,wav,aif,aiff,rm,wma,asf,flac,opus,spx,ra,ape,shn,wv`

#### Scheduler / Cron

| Parameter              | Description                             | Default |
| ---------------------- | --------------------------------------- | ------- |
| `MAINTENANCE_INTERVAL` | Minutes between maintenance runs (1-59) | `15`    |

## Networking

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container. An `ampache-cli` shell function is preinstalled and runs as the nginx user against `/www/ampache/bin/cli`.

```bash
docker exec -it ampache-app bash
ampache-cli
```

## Support & Maintenance

* For community help, tips, and discussions, visit the [Discussions board](/discussions).
* For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
* To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
* Feature requests are welcome but not guaranteed.
* Updates are best-effort, with priority given to active production use and support agreements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

* <https://ampache.org/>
