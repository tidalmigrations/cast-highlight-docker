# Tidal Source Code Analyzer (NOT IN USE)

| :exclamation:  Warning: We are not using CAST Highlight for Code analysis anymore. |
|------------------------------------------------------------------------------------|

When doing source code analysis, Tidal Tools works together with the [CAST Highlight CLI](https://www.castsoftware.com/products/highlight) to execute the analysis.

## High level breakdown

### Online

1. Tidal Tools
   - Exposes the source code analysis command `tidal analyze code --app-id <your-app-id>` (run from directory containing the source code)
   - Handles authentication
   - Hits your Tidal Migrations Workspace `GET apps/#id/cast`
2. Tidal Migrations Platform
   - Creates an app in CAST if it's not already present. This CAST app is now associated with your TMP app at the ID provided.
   - Returns the CAST ID of the app which was created OR the CAST ID of the existing CAST app if you're analyzing the same app again (premium users only).
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

![image](https://user-images.githubusercontent.com/43866616/167871482-c18c3fc3-86dd-49d2-a0e9-178a92a7757c.png)

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

![image](https://user-images.githubusercontent.com/43866616/167871802-cb4f4ec6-375c-4a54-acf2-5602c9409222.png)

## Requirements

- Docker
- Github
  - Access to Tidal Tools repository
- GCP
  - Images are stored in the **Container Registry**. You will need access to `Tidal Migrations` organization.

## Releasing

To create a new docker image that can be downloaded (used) by Tidal Tools, you will need to push to the repository. We use Google Cloud Platform (cloud build) to automate the creation of these images.

1. From the default branch (master), create a new branch. The name of your new branch will be used to create/identify a new image in the GCP container registry. If you are creating a new image to upgrade to a new version of CAST Highlights, name your branch using its version. This will allows us to have a clear image history in case we ever need to "rollback".

   For example:

   ```
   git branch v5.4.18
   ```

   If you are upgrading the CAST CLI version, Please adjust the second line of the Dockerfile. CLI_VERSION refers to the CAST CLI version for your image and we use it in our dashboard to help us keep track of current vs new releases.

2. Push your branch. The build trigger is invoked every time there is a push to this repository (any branch). During the process a new Docker container image is built and tagged as the following:

   ```
   gcr.io/tidal-1529434400027/cast-highlight:$BRANCH_NAME
   Where $BRANCH_NAME corresponds to the git branch name. (ex, v5.4.18)
   ```

   You can find your new image in the GCP container registry, under cast-highlight repository.

3. Done, you can now test this image out locally in Tidal Tools by manually adjusting the docker image used [here](https://github.com/tidalmigrations/tidal-tools/blob/ff5d2bd9cd206f1f305a96d2a976a4a1f06cd59a/pkg/commands/analyze/code/code.go#L25).

4. If everything is ok. (Meaning, you are able to do source code analysis). Create a Pull Request to merge your branch into the default branch (master)

   When your PR is merged, Cloud Build will create another image with the default tag: gcr.io/tidal-1529434400027/cast-highlight:latest

5. That is all!

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
