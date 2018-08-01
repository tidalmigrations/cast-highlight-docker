FROM openjdk:jre-alpine

RUN apk add --no-cache \
    curl \
    perl-json \
    perl-xml-twig

ENV CLI_NAME=Highlight-Automation-Command
ENV APP_DIR=/app/$CLI_NAME
WORKDIR $APP_DIR
RUN curl -sSL https://casthighlight.com/tools/cli/${CLI_NAME}.tar.gz \
    | tar xz -C /app
COPY entrypoint.sh $APP_DIR

ENTRYPOINT ["./entrypoint.sh"]
CMD ["cast"]
