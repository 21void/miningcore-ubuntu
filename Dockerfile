FROM microsoft/dotnet:sdk as build-env

# install build-tools
RUN apt-get update -y && apt-get -y install git cmake build-essential libssl-dev pkg-config libboost-all-dev libsodium-dev

# build
RUN cd /tmp && git clone https://github.com/coinfoundry/miningcore && cd miningcore/src/Miningcore && \
    mkdir /dotnetapp && dotnet publish -c Release --framework netcoreapp2.1 -r ubuntu.16.04-x64 -o /dotnetapp

FROM debian:stretch-slim
RUN useradd -s /bin/bash -u 1111 -m miningcore && \
    apt-get update -y && \
    apt-get autoremove -y && apt-get clean autoclean && \
    apt-get -y install libboost-system1.62.0 libboost-date-time1.62.0 libssl1.0.2 libsodium18 libicu57 libzmq5-dev && \
    mkdir /logger && chmod 777 /logger && chown -R miningcore:miningcore /logger && \
    rm -rf /var/lib/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

WORKDIR /dotnetapp

COPY --chown=miningcore --from=build-env /dotnetapp .

USER miningcore

# API
EXPOSE 4000
# Stratum Ports
EXPOSE 3032-3199
# logging
VOLUME [ "/logger" ]

ENTRYPOINT /dotnetapp/Miningcore -c /config.json
