# Dockerfile for running Ofbiz from trunk

This Dockerfile consists:

The Ofbiz container is built based on the OpenJDK 11 image.

Ofbiz sources are built using gradle inside the new image.

It is possible to change the  entity engine configuration e.g. use
postgres datasource rather than the default derby datasource.

## Environment

* ENV JAVA_OPTS -Xmx2G
* ENV JDBC_LIB_FILE="postgresql-42.4.1.jar" 
* ENV DB_HOST="127.0.0.1"
* ENV DB_NAME="ofbiz"
* ENV DB_USER="ofbiz"
* ENV DB_PASSWORD="ofbiz"
* ENV DOMAINLIST="localhost,127.0.0.1"

## Build Arguments
If you have a local fork of the ofbiz repository, you can use these repository by starting git server
'' git daemon --base-path=. --export-all --reuseaddr --informative-errors --verbose ''
and build the image with these two arguments
''docker build -t ofbiz:trunk --build-arg REPOS_FRAMEWORK_URL=git://192.168.122.1/ofbiz-framework --build-arg REPOS_PLUGIN_URL=git://192.168.122.1/plugins .''
ARG REPOS_FRAMEWORK_URL="https://gitbox.apache.org/repos/asf/ofbiz-framework.git"
ARG REPOS_PLUGIN_URL="https://gitbox.apache.org/repos/asf/ofbiz-plugins.git"

## Startscript
entrystart.sh is a script, that:
* change the configuration of ofbiz
* start app in backgound
* import default data
* stop app
* start app in foreground to get logs over stdout

## TODO
* save image place with different Java version (jdk, jre)
* save image place with using only binary from the build
* different versions beside trunk
* volume definitions 
