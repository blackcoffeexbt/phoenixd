[![Kotlin](https://img.shields.io/badge/Kotlin-1.9.23-blue.svg?style=flat&logo=kotlin)](http://kotlinlang.org)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![](https://img.shields.io/badge/www-Homepage-green.svg)](https://phoenix.acinq.co/server)
[![](https://img.shields.io/badge/www-API_doc-red.svg)](https://phoenix.acinq.co/server/api)

# phoenixd

**phoenixd** is the server equivalent of the popular [phoenix wallet](https://github.com/ACINQ/phoenix) for mobile.
It is written in [Kotlin Multiplatform](https://kotlinlang.org/docs/multiplatform.html) and runs natively on Linux, MacOS (x86 and ARM), and Windows (WSL).

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

## Docker file with ssh tunnel to a remote server

The Dockerfile in .docker creates a docker container that runs phoenixd and uses autossh to establish a reverse ssh tunnel to a remote server.

### Instructions for use

1. Open terminal and cd to .docker
1. Copy .env.example to .env and update the vars accordingly
1. Build and run the container using docker compose `docker compose up --build`
1. The previous command will include the pubkey of your phoenixd docker container. Add this to the .ssh/authorized_hosts file of your ssh server.
1. Stop the docker container by CTRL-Cing, then start the docker container with `docker compose up -d`.
1. Get the http-password by running `docker exec docker-phoenixd cat .phoenix/phoenix.conf`

#### LNbits
If using LNbits, use this funding source by setting your LNbits funding source to

PhoenixdWallet

Endpoint: http://localhost:9740

Key: The http-password value above

## Other useful things

Get the BIP39 seed phrase

`docker exec docker-phoenixd-1 cat .phoenix/seed.dat`

Make a backup of the .phoenixd directory

`docker exec docker-phoenixd-1 tar cpzf phoenix.tar.gz .phoenix`

`docker container cp docker-phoenixd-1:/phoenix/phoenix.tar.gz ~/`

Get node info
`docker exec docker-phoenixd-1  bin/phoenix-cli getinfo`