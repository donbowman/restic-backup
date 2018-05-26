FROM golang:latest as build
LABEL maintainer="don@agilicus.com"

RUN mkdir -p /go/src/github.com/restic \
 && cd /go/src/github.com/restic \
 && git clone https://github.com/restic/restic \
 && cd restic \
 && go run build.go

FROM alpine:latest
RUN adduser -g '' -s /sbin/nologin -D backup \
 && apk --no-cache add ca-certificates
WORKDIR /home/backup
COPY --from=build /go/src/github.com/restic/restic/restic /usr/bin/restic
USER backup
CMD ["/usr/bin/restic"]
