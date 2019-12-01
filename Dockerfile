FROM dlang2/dmd-ubuntu:2.089.0 AS builder
WORKDIR /
COPY . .
RUN dub -v build

#
# either:
#
FROM ubuntu:bionic
RUN \
  apt-get update && \
  apt-get install -y zlib1g libssl1.1 && \
  rm -rf /var/lib/apt/lists/*
#
# or (but doesn't work):
#
#FROM scratch
#COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
#
# and then:
#
WORKDIR /
COPY --from=builder /hello-d .
USER nobody
EXPOSE 8080
ENTRYPOINT ["./hello-d"]
