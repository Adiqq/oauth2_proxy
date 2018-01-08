FROM golang:1.8-alpine
ADD . $GOPATH/src/github.com/bitly/oauth2_proxy
WORKDIR $GOPATH/src/github.com/bitly/oauth2_proxy

# Build *really static*
ENV CGO_ENABLED 0
RUN apk update
RUN apk add git
RUN go get ./...
RUN go install -ldflags '-s' github.com/bitly/oauth2_proxy

FROM alpine
RUN apk add --no-cache ca-certificates
# This part requires Docker version 17.05 or newer
COPY --from=0 /go/bin/oauth2_proxy /bin/oauth2_proxy
COPY ./ca-cert-bundle.crt /usr/local/share/ca-certificates/ca-cert-bundle.crt
RUN update-ca-certificates
ENTRYPOINT ["/bin/oauth2_proxy"]
