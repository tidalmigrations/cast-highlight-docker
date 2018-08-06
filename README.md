# cast-highlight-docker

[![Build Status](https://travis-ci.org/tidalmigrations/cast-highlight-docker.svg?branch=master)](https://travis-ci.org/tidalmigrations/cast-highlight-docker)

Docker image packaging for CAST Highlight Automated Code Scan

## Usage

```
$ docker build -t cast-highlight alpine

$ docker run --rm \
  -v /path/to/sources:/src \
  cast-highlight:latest cast --skipUpload --sourceDir /src 
```

## Passing login credentials

Command line flags:

```
$ docker run --rm \
  -v /path/to/sources:/src \
  cast-highlight:latest cast --sourceDir /src --login admin --password secret
```

Environment variables:

```
$ docker run --rm \
  -v /path/to/sources:/src \
  -e CAST_LOGIN=admin \
  -e CAST_PASSWORD=secret \
  cast-highlight:latest cast --sourceDir /src
```

`.env` file:

```
$ cat /path/to/secrets/.env
CAST_LOGIN=admin
CAST_PASSWORD=secret

$ docker run --rm \
  -v /path/to/sources:/src \
  -v /path/to/secrets:/secrets \
  cast-highlight:latest cast --sourceDir /src
```

**Note:** `.env` file is removed during the `docker run`.
