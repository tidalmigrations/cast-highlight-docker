ARG CLI_NAME=Highlight-Automation-Command
ARG CLI_VERSION=5.4.24

FROM alpine AS builder
RUN apk add --no-cache curl
ARG CLI_NAME
RUN mkdir /app && curl -sSL https://doc.casthighlight.com/tools/cli/${CLI_NAME}.tar.gz \
    | tar xz -C /app

FROM openjdk:11-jre-slim-buster
ARG CLI_NAME
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libxml-libxml-perl \
    libjson-perl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /secrets
COPY --from=builder /app /app
WORKDIR /app/${CLI_NAME}
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["cast"]
