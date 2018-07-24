FROM openjdk:jdk-nanoserver-sac2016

ENV PERL_VERSION 5.28.0.1
ENV PERL_SHA1 22a773ae058119a02577e97447fa298926cee67e

RUN powershell -Command $ErrorActionPreference = 'Stop' ; $ProgressPreference = 'SilentlyContinue' ; \
    Invoke-WebRequest $('http://strawberryperl.com/download/{0}/strawberry-perl-{0}-64bit-portable.zip' -f $env:PERL_VERSION) -OutFile 'perl.zip' -UseBasicParsing ; \
    if ((Get-FileHash perl.zip -Algorithm sha1).Hash -ne $env:PERL_SHA1) { Write-Error 'SHA1 mismatch' } ; \
    Expand-Archive -Path perl.zip -DestinationPath C:\ -Force ; \
    rm perl.zip ; \
    setx /M PATH $('C:\perl\site\bin;C:\perl\bin;C:\c\bin;{0}' -f $env:PATH)

ENV CLI_NAME Highlight-Automation-Command

RUN powershell -Command $ErrorActionPreference = 'Stop' ; $ProgressPreference = 'SilentlyContinue' ; \
    Invoke-WebRequest $('https://casthighlight.com/tools/cli/{0}.tar.gz' -f $env:CLI_NAME) -OutFile 'cast.zip' -UseBasicParsing ; \
    Expand-Archive -Path cast.zip -DestinationPath C:\ -Force ; \
    rm cast.zip

WORKDIR C:\$CLI_NAME
ENTRYPOINT ["java", "-jar", "HighlightAutomation.jar"]
