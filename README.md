## Confluence in Docker

[![CircleCI Build Status](https://img.shields.io/circleci/project/million12/docker-confluence/master.svg)](https://circleci.com/gh/millio12/docker-confluence)
[![GitHub Open Issues](https://img.shields.io/github/issues/million12/docker-confluence.svg)](https://github.com/million12/docker-confluence)
[![GitHub Stars](https://img.shields.io/github/stars/million12/docker-confluence.svg)](https://github.com/million12/docker-confluence)
[![GitHub Forks](https://img.shields.io/github/forks/million12/docker-confluence.svg)](https://github.com/million12/docker-confluence)  
[![Stars on Docker Hub](https://img.shields.io/docker/stars/million12/confluence.svg)](https://hub.docker.com/r/million12/confluence)
[![Pulls on Docker Hub](https://img.shields.io/docker/pulls/million12/confluence.svg)](https://hub.docker.com/r/million12/confluence)  
[![Docker Layers](https://badge.imagelayers.io/million12/confluence:latest.svg)](https://hub.docker.com/r/million12/confluence)

[Docker image](https://hub.docker.com/r/million12/confluence) with [Atlassian Confluence](https://www.atlassian.com/software/confluence) build in docker. Integrated with MySQL support. Base image is [million12/centos-supervisor](https://hub.docker.com/r/million12/centos-supervisor/) which is based on offcial CentOS-7 image.  

User will need a licence to be able to finish setup. Either evaluation one or full.

This image can be run just by itself but then it will have support only for Confluence build-in database HSQL or PostgreSQL.

## Basic Usage

    docker run \
    -d \
    --name confluence \
    -p 8090:8090 \
    million12/confluence

### Setup
Access setup page under [docker.ip:8090]() and follow installation procedure.  
**Atlassian Confluence licence is required to finish installation.**

## ENVIRONEMNTAL VARIABLES
This image comes with few environmental variables that will be needed to connect it to MYSQL or PostgreSQL container.  

`DB_SUPPORT` - select mysql support.  
`DB_ADDRESS` - Database address (ip or domain.com format).  
`DB_NAME` - database name.   

### PostgreSQL Docker image
    docker run \
    -d \
    --name confluence-db \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -e POSTGRES_USER=admin \
    -e POSTGRES_DB=confluencedb \
    postgres

### Data container

    docker run -d \
      --name confluence-data \
      -v /data/confluence/confluence-install:/opt/atlassian \
      -v /data/confluence/confluence-data:/var/atlassian \
      busybox:latest

### Confluence container

    docker run -d \
      --name confluence \
      --link confluence-db:confluence.db \
      --volumes-from confluence-data \
      -e DB_ADDRESS=confluence.db \
      -e DB_NAME=confluencedb \
      -p 80:8090 \
      million12/confluence

### Docker troubleshooting


Use docker command to see if all required containers are up and running:

    $ docker ps -a

Check online logs of confluence container:

    $ docker logs confluence

Attach to running confluence container (to detach the tty without exiting the shell,
use the escape sequence Ctrl+p + Ctrl+q):

    $ docker attach confluence

Sometimes you might just want to review how things are deployed inside a running container, you can do this by executing a _bash shell_ through _docker's exec_ command:

    docker exec -i -t confluence /bin/bash

History of an image and size of layers:

    docker history --no-trunc=true million12/confluence | tr -s ' ' | tail -n+2 | awk -F " ago " '{print $2}'

---
## Author

Author: Przemyslaw Ozgo [linux@ozgo.info](mailto:linux@ozgo.info)

Licensed under: The MIT License (MIT)

**Sponsored by** [PrototypeBrewery.io - the new prototyping tool](http://prototypebrewery.io/)
for building fully interactive prototypes of your website or web app. Built on top of
Neos CMS and Zurb Foundation framework.
