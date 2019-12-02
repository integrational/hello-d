FROM dlang2/ldc-ubuntu:beta AS builder
WORKDIR /build
COPY . .
RUN dub build -f -n -b release

FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y zlib1g libssl1.1 && \
    rm -rf /var/lib/apt/lists/*
USER nobody
WORKDIR /app
COPY --from=builder /build/hello-d ./app
EXPOSE 8080
ENTRYPOINT ["./app"]
