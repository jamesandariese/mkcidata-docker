ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ARG XORRISO_VERSION

RUN apk add "xorriso=${XORRISO_VERSION}"

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
