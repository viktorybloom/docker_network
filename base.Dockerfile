FROM alpine:latest as builder

RUN apk add --no-cache \
        iproute2 \
        iptables \
        iputils \
        tcpdump \
        bash


COPY docker_network.sh /docker_network.sh

RUN chmod +x /docker_network.sh

ENTRYPOINT ["/docker_network.sh"]
