<p align="center" style="text-align: center">
  <img src="https://github.com/YouROK/TorrServer/assets/144587546/53f7175a-cda4-4a06-86b6-2ac07582dcf1" width="33%"><br/>
</p>

<p align="center">
  Simple and powerful tool for streaming torrents.
  <br/>
  <br/>
  <a href="https://github.com/YouROK/TorrServer/blob/master/LICENSE">
    <img alt="GitHub" src="https://img.shields.io/github/license/YouROK/TorrServer"/>
  </a>
  <a href="https://goreportcard.com/report/github.com/YouROK/TorrServer">
    <img src="https://goreportcard.com/badge/github.com/YouROK/TorrServer" />
  </a>
  <a href="https://pkg.go.dev/github.com/YouROK/TorrServer">
    <img src="https://pkg.go.dev/badge/github.com/YouROK/TorrServer.svg" alt="Go Reference"/>
  </a>
  <a href="https://github.com/YouROK/TorrServer/issues">
    <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat" alt="CodeFactor" />
  </a>
  <a href="https://github.com/YouROK/TorrServer/actions/workflows/github-actions-docker.yml" rel="nofollow">
    <img src="https://img.shields.io/github/actions/workflow/status/YouROK/TorrServer/github-actions-docker.yml?logo=Github" alt="Build" />
  </a>
  <a href="https://github.com/YouROK/TorrServer/tags" rel="nofollow">
    <img alt="GitHub tag (latest SemVer pre-release)" src="https://img.shields.io/github/v/tag/YouROK/TorrServer?include_prereleases&label=version"/>
  </a>
</p>

## Introduction

TorrServer is a program that allows users to view torrents online without the need for preliminary file downloading.
The core functionality of TorrServer includes caching torrents and subsequent data transfer via the HTTP protocol,
allowing the cache size to be adjusted according to the system parameters and the user's internet connection speed.

## Features

- Caching
- Streaming
- Local and Remote Server
- Viewing torrents on various devices
- Integration with other apps through API
- Cross-browser modern web interface
- Optional DLNA server

## Getting Started

### Installation

Download the application for the required platform in the [releases](https://github.com/YouROK/TorrServer/releases) page. After installation, open the link <http://127.0.0.1:8090> in the browser.

#### Windows

Run `TorrServer-windows-amd64.exe`.

#### Linux

Run in console

```bash
curl -s https://raw.githubusercontent.com/YouROK/TorrServer/master/installTorrServerLinux.sh | sudo bash
```

#### macOS

Run in Terminal.app

```bash
curl -s https://raw.githubusercontent.com/YouROK/TorrServer/master/installTorrServerMac.sh -o installTorrserverMac.sh && chmod 755 installTorrServerMac.sh && bash ./installTorrServerMac.sh
```

Alternative install script for Intel Macs: <https://github.com/dancheskus/TorrServerMacInstaller>

#### IOCage Plugin (Unofficial)

On FreeBSD (TrueNAS/FreeNAS) you can use this plugin: <https://github.com/filka96/iocage-plugin-TorrServer>

#### NAS Systems (Unofficial)

- Several releases are available through this link: <https://github.com/vladlenas>
- **Synology NAS** packages repo source: <https://grigi.lt>

### Server args

- `--port PORT`, `-p PORT` - web server port (default 8090)
- `--ssl` - enables https for web server
- `--sslport PORT` -  web server https port (default 8091). If not set, will be taken from db (if stored previously) or the default will be used.
- `--sslcert PATH` -  path to ssl cert file. If not set, will be taken from db (if stored previously) or default self-signed certificate/key will be generated.
- `--sslkey PATH` - path to ssl key file. If not set, will be taken from db (if stored previously) or default self-signed certificate/key will be generated.
- `--path PATH`, `-d PATH` - database and config dir path
- `--logpath LOGPATH`, `-l LOGPATH` - server log file path
- `--weblogpath WEBLOGPATH`, `-w WEBLOGPATH` - web access log file path
- `--rdb`, `-r` - start in read-only DB mode
- `--httpauth`, `-a` - enable http auth on all requests
- `--dontkill`, `-k` - don't kill server on signal
- `--ui`, `-u` - open torrserver page in browser
- `--torrentsdir TORRENTSDIR`, `-t TORRENTSDIR` - autoload torrents from dir
- `--torrentaddr TORRENTADDR` - Torrent client address (format [IP]:PORT, ex. :32000, 127.0.0.1:32768 etc)
- `--pubipv4 PUBIPV4`, `-4 PUBIPV4` - set public IPv4 addr
- `--pubipv6 PUBIPV6`, `-6 PUBIPV6` - set public IPv6 addr
- `--searchwa`, `-s` - allow search without authentication
- `--help`, `-h` - display this help and exit
- `--version` - display version and exit

Example:

```bash
TorrServer-darwin-arm64 [--port PORT] [--path PATH] [--logpath LOGPATH] [--weblogpath WEBLOGPATH] [--rdb] [--httpauth] [--dontkill] [--ui] [--torrentsdir TORRENTSDIR] [--torrentaddr TORRENTADDR] [--pubipv4 PUBIPV4] [--pubipv6 PUBIPV6] [--searchwa]
```

### Running in Docker & Docker Compose

Run in console

```bash
docker run --rm -d --name torrserver -p 1024:6881 ghcr.io/sleepy0/torrserver:latest
```

For running in persistence mode, just mount volume to container by adding `-v ~/ts:/app`, where `~/ts` folder path is just example, but you could use it anyway... Result example command:

```bash
docker run --rm -d --name torrserver -v ~/ts:/app -p 1024:6881 ghcr.io/sleepy0/torrserver:latest
```

Example with optional parameters:

```bash
docker run --rm -d --name torrserver -v ~/ts:/app -p 1024:6881 ghcr.io/sleepy0/torrserver:latest --dontkill
```

#### Docker Compose

```yml
# docker-compose.yml

services:
  torrserver:
    image: ghcr.io/sleepy0/torrserver:latest
    container_name: torrserver
    volumes:
      - './.torrents:/app/torrents'
      - './.config:/app/config'
    ports:
      - '1024:6881/tcp'
      - '1024:6881/udp'
    restart: unless-stopped
    command: ["--dontkill"]
    labels:
      - homepage.group=Links
      - homepage.name=torrserver
      - homepage.description=Simple and powerful tool for streaming torrents
      - homepage.icon=torrserver
      - homepage.href=https://subdomain.domain.tld/
    

networks:
  default:
    name: caddy_default
    external: true

```

### Smart TV (using Media Station X)

1. Install **Media Station X** on your Smart TV (see [platform support](https://msx.benzac.de/info/?tab=PlatformSupport))

2. Open it and go to: **Settings -> Start Parameter -> Setup**

3. Enter current ip and port of the TorrServe(r), e.g. `127.0.0.1:8090`

## Development

#### Go server

To run the Go server locally, just run

```bash
cd server
go run ./cmd
```

#### Web development

To run the web server locally, just run

```bash
yarn start
```

More info at https://github.com/YouROK/TorrServer/tree/master/web#readme

### Build

#### Server

- Install [Golang](https://golang.org/doc/install) 1.20+
- Go to the TorrServer source directory
- Run build script under linux or macOS `build-all.sh`

#### Web

- Install **npm** and **yarn**
- Go to the web directory
- Run `NODE_OPTIONS=--openssl-legacy-provider yarn build`

#### Android

To build an Android server you will need the Android Toolchain.

#### Swagger

`swag` must be installed on the system to [re]build Swagger documentation.

```bash
go install github.com/swaggo/swag/cmd/swag@latest
cd server; swag init -g web/server.go

# Documentation can be linted using
swag fmt
```
## API

### API Docs

API documentation is hosted as Swagger format available at path `/swagger/index.html`.

## Authentication

The users data file should be located near to the settings. Basic auth, read more in wiki <https://en.wikipedia.org/wiki/Basic_access_authentication>.

`accs.db` in JSON format:

```json
{
    "User1": "Pass1",
    "User2": "Pass2"
}
```
Note: You should enable authentication with -a (--httpauth) TorrServer startup option.

## Whitelist/Blacklist IP

The lists file should be located in the same directory with config.db.

- Whitelist file name: `wip.txt`
- Blacklist file name: `bip.txt`

Whitelist has priority over everything else.

Example:

```text
local:127.0.0.0-127.0.0.255
127.0.0.0-127.0.0.255
local:127.0.0.1
127.0.0.1
# at the beginning of the line, comment
```

## Donate

- [YooMoney](https://yoomoney.ru/to/410013733697114/200)
- SberBank Card: **5484 4000 2285 7839**


## Thanks to everyone who tested and helped

- [anacrolix](https://github.com/anacrolix) Matt Joiner
- [tsynik](https://github.com/tsynik)
- [dancheskus](https://github.com/dancheskus) for react web GUI and PWA code
- [kolsys](https://github.com/kolsys) for initial Media Station X support
- [damiva](https://github.com/damiva) for Media Station X code updates
- [vladlenas](https://github.com/vladlenas) for NAS builds
- [Nemiroff](https://github.com/Nemiroff) Tw1cker
- [spawnlmg](https://github.com/spawnlmg) SpAwN_LMG for testing
- [TopperBG](https://github.com/TopperBG) Dimitar Maznekov for Bulgarian web translation
- [FaintGhost](https://github.com/FaintGhost) Zhang Yaowei for Simplified Chinese web translation
- [Anton111111](https://github.com/Anton111111) Anton Potekhin for sleep on Windows fixes
- [lieranderl](https://github.com/lieranderl) Evgeni for adding SSL support code
- [cocool97](https://github.com/cocool97) for openapi API documentation and torrent categories
- [shadeov](https://github.com/shadeov) for README improvements
- [butaford](https://github.com/butaford) Pavel for make docker file and scripts
- [filimonic](https://github.com/filimonic) Alexey D. Filimonov
- [leporel](https://github.com/leporel) Viacheslav Evseev
- and others
