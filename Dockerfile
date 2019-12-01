FROM dlang2/dmd-ubuntu:2.089.0 AS build
COPY . /
WORKDIR /
RUN dub -v build

FROM ubuntu:bionic
RUN \
  apt-get update && \
  apt-get install -y zlib1g libssl1.1 && \
  rm -rf /var/lib/apt/lists/*
COPY --from=build /hello-d /
USER nobody
EXPOSE 8080
ENTRYPOINT ["/hello-d"]
