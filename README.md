# Tidal Source Code Analyzer

When doing source code analysis, Tidal Tools works together with the CAST highlight CPI to execute the analysis.

## High level breakdown

### Online

1. Tidal Tools
    - Exposes the source code analysis command `tidal analyze code --app-id <your-app-id>` (run from directory containing the source code)
    - Handles authentication
    - Hits your Tidal Migrations Workspace `GET apps/#id/cast`
2. Tidal Migrations Platform
    - Creates an app in CAST if it's not already present. This CAST app is now associated with your TMP app at the ID provided.
    - Returns the CAST ID of the app which was created / the CAST ID of the existing CAST app if you're analyzing the same app again (premium users only).
3. Tidal Tools
    - Pulls docker image containing CAST Highlight CLI (that's why you're here)
    - Runs the CAST CLI in this container
4. CAST CLI
    - Analyzes your app and uploads it to CAST with the CAST ID which TMP returned in step 2
5. Tidal Tools
    - After the analysis is completed successfully, Tidal Tools will notify TMP that the app has been analyzed
6. Tidal Migrations Platform
    - Starts a worker to check on the status of the analysis in CAST. This runs async and periodically checks to see if the analysis is complete
    - When the analysis is complete, TMP gets the analysis data from CAST and updates your TMP app with the analysis information. This propagates to the frontend and the user is now able to see their source code analysis result when they view their app

### Offline

1. Tidal Tools
    - Exposes the source code analysis command `tidal analyze code --app-id <your-app-id>` (run from directory containing the source code). Providing the `--app-id` here is optional. If provided, the ID is saved as a comment with the ZIP file.
    - Runs the CAST CLI in a docker container (obtained from running `tidal backup` on an offline server then transferring this over, see [the guide](https://guides.tidalmg.com/tidal-offline.html#create-the-tidal-tools-archive-file-for-offline-use).).
    - Saves the resulting ZIP file to the current directory, or to a path provided.
2. The User
    - Sends this result ZIP file to Tidal Support.
3. Tidal Support
    - Uploads the result ZIP file to CAST on behalf of the user.
    - Manually triggers the association between the Tidal Migrations Platform app and the CAST app.

## Requirements
- Docker 
- Gitlab
    - Access to Tidal Tools repository [here](https://gitlab.com/subdata/tidal-tools)
- GCP
    - Images are stored in the [Container Registry](https://console.cloud.google.com/gcr/images/tidal-1529434400027/global/cast-highlight?authuser=1&project=tidal-1529434400027). You will need access to `Tidal Migrations` organization and to the `Tidal-Tools` project (id -> **tidal-1529434400027**)

## Releasing

To release new docker image, make a commit to `master` in this repository and Google Code Build will deploy a new docker image to the registry `gcr.io/tidal-1529434400027/cast-highlight` with the `latest` tag.

You should see a notification in Slack, #tidal-tools, regarding a successful image build. Alternatively, you can also check: https://console.cloud.google.com/cloud-build/builds?project=tidal-1529434400027

## Run the container independently

```
$ docker build -t cast-highlight .

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
