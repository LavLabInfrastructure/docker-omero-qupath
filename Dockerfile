ARG OMERO_PLUGIN_VERSION=dev
FROM quay.io/galaxy/qupath-headless:__QUPATH_TAG__

LABEL maintainer=""

# Copy the OMERO plugin jar (expecting it in the build context)
COPY qupath-extension-omero.jar /opt/qupath/QuPath/lib/app/qupath-extension.jar

# If a QuPath.cfg exists anywhere under /opt/qupath, add the plugin to the application classpath
RUN set -eux; \
    cfg=$(find /opt/qupath -name "QuPath.cfg" -print -quit) && \
    if [ -n "$cfg" ]; then \
        sed -i '/^\[Application\]$/a app.classpath=$APPDIR/qupath-extension.jar' "$cfg"; \
    fi

ENV OMERO_PLUGIN_VERSION=${OMERO_PLUGIN_VERSION}

# Keep base image behavior (do not override entrypoint/CMD)
