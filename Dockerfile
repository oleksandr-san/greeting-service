ARG BASE_IMAGE=ekidd/rust-musl-builder:1.51.0

FROM ${BASE_IMAGE} AS build

# create a new empty shell project
RUN USER=root cargo new --bin greeting-service
WORKDIR /greeting-service

# copy over our manifests
COPY Cargo.lock ./Cargo.lock
COPY Cargo.toml ./Cargo.toml

# this build step will cache your dependencies. TODO: make it work with MUSL
# RUN cargo build --release

# copy our source tree
COPY src ./src

# build for release
# RUN rm ./target/*/release/greeting-service*
RUN cargo build --release

# our final base
FROM scratch

# copy the build artifact from the build stage
COPY --from=build /greeting-service/target/x86_64-unknown-linux-musl/release/greeting-service /

# set the startup command to run our binary
ENV ROCKET_ADDRESS 0.0.0.0
CMD ["/greeting-service"]