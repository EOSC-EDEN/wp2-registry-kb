FROM alpine:3.24
RUN apk add --no-cache bash curl
COPY kb /kb/kb
COPY memberships /kb/memberships
COPY scripts/load.sh /kb/scripts/load.sh
USER nobody
ENTRYPOINT ["/kb/scripts/load.sh"]
