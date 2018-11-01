[![Build Status](https://travis-ci.org/21void/miningcore-ubuntu.svg?branch=master)](https://travis-ci.org/21void/miningcore-ubuntu)

## miningcore-ubuntu

Unofficial [Miningcore](https://github.com/coinfoundry/miningcore) docker-image using smaller debian:stretch-slim as base image

## usage

The image expects a valid pool configuration file as volume argument:

```bash
$ docker run -d -p 3032:3032 -v /path/to/config.json:/config.json:ro 21void/miningcore-ubuntu:travis-latest
```

As shown in the example above you also need to expose all the stratum ports you've specified in config.json.
