ARG CLI_NAME=Highlight-Automation-Command
ARG CLI_VERSION=5.3.34

FROM busybox AS builder
ARG CLI_NAME
ADD https://doc.casthighlight.com/tools/cli/${CLI_NAME}.tar.gz .
RUN mkdir /app \
    && tar -xzv -C /app -f ${CLI_NAME}.tar.gz \
    && rm ${CLI_NAME}.tar.gz

FROM openjdk:8-jre-slim
ARG CLI_NAME
RUN apt-get update && apt-get install -y \
    libxml-libxml-perl \
    libjson-perl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /secrets
COPY --from=builder /app /app
WORKDIR /app/${CLI_NAME}
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["cast"]
