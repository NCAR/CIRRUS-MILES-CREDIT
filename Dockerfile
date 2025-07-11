# Note: This Docker file is unique to an Actix framework application
# other types of apps might vary
FROM docker.io/rust:1-slim-bookworm AS build
# cargo package name: customize here or provide via --build-arg
ARG pkg=CIRRUSTest
WORKDIR /build
COPY . .
RUN --mount=type=cache,target=/build/target \
    --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    set -eux; \
    cargo build --release; \
    objcopy --compress-debug-sections target/release/$pkg ./main

FROM docker.io/debian:bookworm-slim
WORKDIR /app
## copy the main binary
## add more files below if needed
COPY --from=build /build/main ./
EXPOSE 8080
CMD ./main

