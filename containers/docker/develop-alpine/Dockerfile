FROM alpine:3.5

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/iron-bank/go-IRON && \
  (cd go-IRON && make iron) && \
  cp go-IRON/build/bin/iron /iron && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-IRON && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/iron"]
