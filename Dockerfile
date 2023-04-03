############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git bash wget curl
WORKDIR /build
RUN git clone --progress https://github.com/calmw/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --abbrev=0 --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

############################
# STEP 2 build a small image
############################
FROM alpine

COPY --from=builder /tmp/v2ray.tgz /tmp
ARG wkdir=v2ray
WORKDIR $wkdir
ADD config.json /$wkdir/config.json
RUN apk update && apk add ca-certificates && \
    mkdir -p /usr/bin/v2ray && \
    tar xvfz /tmp/v2ray.tgz -C /usr/bin/v2ray

RUN mkdir v2ray_log

ENV PATH /usr/bin/v2ray:$PATH
CMD ["v2ray", "run"]