# docker-omero-qupath

This repository builds a secondary Docker image based on `quay.io/galaxy/qupath-headless` that bundles the latest `qupath-extension-omero` plugin into ` /opt/qupath/QuPath/lib/app` and adds the plugin to the application classpath.

Image tagging
- The image tag is formed as: `${QUPATH_IMAGE_VERSION}-${OMERO_PLUGIN_VERSION}`

How it works
- A GitHub Actions workflow fetches the latest `qupath-extension-omero` release (or falls back to the main commit SHA), builds the plugin jar, copies it into the repository build context, builds the Docker image, pushes it to GHCR (`ghcr.io/<owner>/docker-qupath:<tag>`), and creates a GitHub release with the same tag.

Local build
1. Build the plugin jar locally (or let the workflow do it):

```bash
# clone plugin and build
git clone https://github.com/qupath/qupath-extension-omero.git
cd qupath-extension-omero
./gradlew clean assemble -x test
cp build/libs/*.jar ../docker-omero-qupath/qupath-extension-omero.jar
cd ../docker-omero-qupath

# build the docker image (set desired base image tag and plugin version)
docker build --build-arg QUPATH_IMAGE_VERSION=latest --build-arg OMERO_PLUGIN_VERSION=1.2.3 -t my-qupath:latest .
```

GitHub Actions
- The workflow is in `.github/workflows/build-and-publish.yml` and runs on `push` to `main`, on a weekly schedule, or manually via workflow_dispatch.
