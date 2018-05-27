FROM golang:latest as build
LABEL maintainer="don@agilicus.com"

# Build v0.9.0. This commit-id was
# signed by 91A6868BD3F7A907
# https://github.com/restic/restic/issues/1819 for the sed
RUN mkdir -p /go/src/github.com/restic \
 && cd /go/src/github.com/restic \
 && git clone https://github.com/restic/restic \
 && cd restic \
 && git checkout -b build  e40191942da7e83e45f995cf9f2d5ae54f97289f \
 && sed -i -e 's?return.*?return true?' internal/ui/termstatus/background_linux.go \
 && sed -i -e 's?func.*SetStatus.*?&\n        return\n?' internal/ui/termstatus/status.go \
 && sed -i -e '/go-isatty/d' -e 's?return isatty.*?return false?' internal/ui/termstatus/terminal_unix.go \
 && go run build.go


FROM busybox:latest
COPY --from=build /go/src/github.com/restic/restic/restic /usr/bin/restic
COPY --from=build /etc/ssl /etc/ssl

ADD auto-backup /usr/bin/auto-backup
ENTRYPOINT [ "/usr/bin/auto-backup" ]
