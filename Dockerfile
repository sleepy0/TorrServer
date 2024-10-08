### FRONT BUILD START ###
FROM --platform=$BUILDPLATFORM node:16-alpine AS front
COPY ./web /app
WORKDIR /app
# Build front once upon multiarch build
RUN yarn install && yarn run build
### FRONT BUILD END ###


### BUILD TORRSERVER MULTIARCH START ###
FROM --platform=$BUILDPLATFORM golang:1.21.2-alpine AS builder

COPY . /opt/src
COPY --from=front /app/build /opt/src/web/build

WORKDIR /opt/src

ARG TARGETARCH

# Step for multiarch build with docker buildx
ENV GOARCH=$TARGETARCH

# Build torrserver
RUN apk add --update g++ \
&& go run gen_web.go \
&& cd server \
&& go mod tidy \
&& go clean -i -r -cache \
&& go build -ldflags '-w -s' --o "torrserver" ./cmd 
### BUILD TORRSERVER MULTIARCH END ###


### UPX COMPRESSING START ###
FROM debian:buster-slim AS compressed

COPY --from=builder /opt/src/server/torrserver ./torrserver

RUN apt-get update && apt-get install -y upx-ucl && upx --best --lzma ./torrserver
# Compress torrserver only for amd64 and arm64 no variant platforms
# ARG TARGETARCH
# ARG TARGETVARIANT
# RUN if [ "$TARGETARCH" == 'amd64' ]; then compress=1; elif [ "$TARGETARCH" == 'arm64' ] && [ -z "$TARGETVARIANT"  ]; then compress=1; else compress=0; fi \
# && if [[ "$compress" -eq 1 ]]; then ./upx --best --lzma ./torrserver; fi
### UPX COMPRESSING END ###


### BUILD MAIN IMAGE START ###
FROM alpine

ENV TS_CONF_PATH="/app/config"
ENV TS_TORR_DIR="/app/torrents"
ENV TS_HTTP_PORT=80
ENV TS_TORR_PORT=6881
ENV GODEBUG=madvdontneed=1

EXPOSE ${TS_HTTP_PORT}
EXPOSE ${TS_TORR_PORT}/tcp
EXPOSE ${TS_TORR_PORT}/udp

COPY --from=compressed ./torrserver /usr/local/bin/torrserver

RUN apk add --no-cache --update ffmpeg \
    && mkdir -p $TS_CONF_PATH \
    && mkdir -p $TS_TORR_DIR

ENTRYPOINT torrserver --path $TS_CONF_PATH --port "$TS_HTTP_PORT" --torrentsdir "$TS_TORR_DIR" --torrentaddr ":$TS_TORR_PORT"
### BUILD MAIN IMAGE end ###
