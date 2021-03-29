# cast-highlight-docker

Docker image packaging for CAST Highlight Automated Code Scan

## Releasing

To release new docker image, make a commit to `master` in this repository and Google Code Build will deploy a new docker image to the registry `gcr.io/tidal-1529434400027/cast-highlight` with the `latest` tag.

You should see a notification in Slack, #tidal-tools, regarding a successful image build. Alternatively, you can also check: https://console.cloud.google.com/cloud-build/builds?project=tidal-1529434400027

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
