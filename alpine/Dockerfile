FROM openjdk:jre-alpine

RUN apk add --no-cache \
    bash \
    curl \
    perl-json \
    perl-xml-libxml

ENV CLI_NAME=Highlight-Automation-Command
ENV CLI_VERSION=5.3.30
ENV APP_DIR=/app/$CLI_NAME
WORKDIR $APP_DIR
RUN curl -sSL https://doc.casthighlight.com/tools/cli/${CLI_NAME}.tar.gz \
    | tar xz -C /app
COPY entrypoint.sh $APP_DIR
RUN mkdir /secrets

ENTRYPOINT ["./entrypoint.sh"]
CMD ["cast"]
