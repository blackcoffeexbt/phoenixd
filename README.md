[![Kotlin](https://img.shields.io/badge/Kotlin-1.9.23-blue.svg?style=flat&logo=kotlin)](http://kotlinlang.org)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![](https://img.shields.io/badge/www-Homepage-green.svg)](https://phoenix.acinq.co/server)
[![](https://img.shields.io/badge/www-API_doc-red.svg)](https://phoenix.acinq.co/server/api)

# phoenixd

**phoenixd** is the server equivalent of the popular [phoenix wallet](https://github.com/ACINQ/phoenix) for mobile.
It is written in [Kotlin Multiplatform](https://kotlinlang.org/docs/multiplatform.html) and runs natively on Linux, MacOS (x86 and ARM), and Windows (WSL).

## Nostr Wallet Connect Docker Container

The Dockerfile in .docker creates a docker container that runs phoenixd and satdress to allow phoenixd as a nostr wallet connect service provider.

### Instructions for use

1. Open terminal and cd to .docker
1. `mkdir phoenix-data`
1. `sudo chmod 0777 -R phoenix-data`
1. Build the container using docker compose `docker compose build`. If building on an arm64 host (i.e. a raspberry pi), use the build-arg `docker compose build --build-arg ARCH=arm64`.
1. Start the container using `docker compose up -d`.

## NWC configuration

1. NWC connections are defined in the ./satdress/config.yml file.
1. After updating the config file, restart the container using `docker compose restart`.

### Useful Commands

**NWC connection string**
```shell
/usr/local/bin/satdress-cli --conf=.satdress/config.yml nwc connect-string --user=nwc
```

**Generate some keys**
```shell
docker exec docker-phoenixd-1 /usr/local/bin/satdress-cli keygen
```

**View satdress logs**
```shell
docker exec docker-phoenixd-1 tail -f logs/satdress.err
```

## Build

### Native Linux/WSL

Requires `libsqlite-dev` and `libcurl4-gnutls-dev`, both compiled against `glibc 2.19`.

```shell
./gradlew packageLinuxX64
```

### Native MacOS x64
```shell
./gradlew packageMacOSX64
```

### Native MacOS arm64
```shell
./gradlew packageMacOSArm64
```

### JVM
```shell
./gradlew distZip
```