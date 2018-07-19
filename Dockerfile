FROM openjdk:jre-alpine

RUN apk add --no-cache \
    curl \
    perl-json \
    perl-xml-twig

ENV CLI_NAME Highlight-Automation-Command
WORKDIR /app/$CLI_NAME
RUN curl -SL https://casthighlight.com/tools/cli/${CLI_NAME}.tar.gz \
    | tar xz -C /app

ENTRYPOINT ["java", "-jar", "HighlightAutomation.jar"]
