# Use Ubuntu image for building for compatibility with macOS arm64 builds
FROM eclipse-temurin:21-jdk-jammy AS BUILD

# Set necessary args and environment variables for building phoenixd
ARG PHOENIXD_BRANCH=v0.3.1
ARG PHOENIXD_COMMIT_HASH=b735020e66daa01512e8fb2f47274b25916b207e

# Upgrade all packages and install dependencies
RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends bash git make \
    && apt clean

RUN wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz \
&& tar -xvf go1.22.5.linux-amd64.tar.gz \
&& mv go /usr/local

# Set environment variables for Go
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

WORKDIR /satdress
RUN git clone https://github.com/braydonf/satdress.git .
RUN make \
    && mkdir -p /var/local/bin \
    && mv satdress /var/local/bin/satdress \
    && mv satdress-cli /var/local/bin/satdress-cli \
    && chmod +x /var/local/bin/satdress-cli \
    && chmod +x /var/local/bin/satdress

RUN ls -l /var/local/bin

# Git pull phoenixd source at specified tag/branch and compile phoenixd
WORKDIR /phoenixd
RUN git clone --recursive --single-branch --branch ${PHOENIXD_BRANCH} -c advice.detachedHead=false \
    https://github.com/ACINQ/phoenixd . \
    && test `git rev-parse HEAD` = ${PHOENIXD_COMMIT_HASH} || exit 1 \
    && ./gradlew distTar

# Alpine image to minimize final image size
FROM eclipse-temurin:21-jre-alpine as FINAL

# Upgrade all packages and install dependencies
RUN apk update \
    && apk upgrade --no-interactive
RUN apk add --update --no-cache bash openssh-client autossh

# Create a phoenix group and user
RUN addgroup -S phoenix -g 1000 \
    && adduser -S phoenix -G phoenix -u 1000 -h /phoenix
USER phoenix

RUN mkdir -p /phoenix/.phoenix && \
    chown -R phoenix:phoenix /phoenix    

#  set permissions for the phoenix user
RUN chown -R phoenix:phoenix /phoenix/.phoenix
# make it writable by the phoenix user
RUN chmod -R 777 /phoenix/.phoenix

# Unpack the release
WORKDIR /phoenix
COPY --chown=phoenix:phoenix --from=BUILD /phoenixd/build/distributions/phoenix-*-jvm.tar .
RUN tar --strip-components=1 -xvf phoenix-*-jvm.tar

# Copy satdress binaries from the BUILD stage
COPY --from=BUILD /var/local/bin/satdress /usr/local/bin/satdress
COPY --from=BUILD /var/local/bin/satdress-cli /usr/local/bin/satdress-cli

# make directory /phoenix/.satdress/data
RUN mkdir -p /phoenix/.satdress/data
RUN mkdir -p /phoenix/logs

# Indicate that the container listens on port 9740
EXPOSE 9740

# Expose default data directory as VOLUME
VOLUME [ "/phoenix" ]

# Add the startup script
COPY startup.sh /usr/local/bin/startup.sh

# Run the daemon with SSH tunnel setup
ENTRYPOINT ["/usr/local/bin/startup.sh"]