FROM eclipse-temurin:21-jre-alpine
ARG pdfgen=0
RUN uname -m > /arch

RUN apk add wget libxml2-utils

RUN mkdir -p /opt/saxon/lib \
    && adduser --disabled-password --gecos "" --home /work/ --shell /bin/bash omegat && mkdir -p /work/root/doc_src \
    && mkdir -p /work/.fop && chown omegat /work/.fop \
    && wget https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-1.79.2.zip -O /tmp/docbook-xsl.zip \
    && unzip /tmp/docbook-xsl.zip -d /opt && rm /tmp/docbook-xsl.zip \
    && wget https://www.xmlmind.com/ditac/_whc/whc-3_6_0.zip -O /tmp/whc.zip \
    && unzip /tmp/whc.zip -d /opt && rm /tmp/whc.zip && rm -rf /opt/whc-3_6_0/doc /opt/whc-3_6_0/src /opt/whc-3_6_0/docsrc \
    && wget https://downloads.apache.org/ant/binaries/apache-ant-1.10.14-bin.zip -O /tmp/ant.zip \
    && unzip /tmp/ant.zip -d /opt && rm /tmp/ant.zip && rm -rf /opt/apache-ant-1.10.14/manual \
    && wget https://dlcdn.apache.org/xmlgraphics/fop/binaries/fop-2.10-bin.zip -O /tmp/fop.zip \
    && unzip /tmp/fop.zip -d /opt && rm /tmp/fop.zip && rm -rf /opt/fop-2.10/javadocs \
    && mkdir /work/docbook-xml-4.5 && wget https://docbook.org/xml/4.5/docbook-xml-4.5.zip -O /tmp/docbook-xml-4.5.zip \
    && unzip /tmp/docbook-xml-4.5.zip -d /work/docbook-xml-4.5 && rm /tmp/docbook-xml-4.5.zip \
    && wget https://docbook.org/xml/5.0.1/docbook-5.0.1.zip -O /tmp/docbook-5.0.1.zip \
    && unzip /tmp/docbook-5.0.1.zip -d /work && rm /tmp/docbook-5.0.1.zip && rm -rf /work/docbook-5.0.1/docs /work/docbook-5.0.1/tools

COPY lib/saxon*.jar /opt/saxon/lib/
COPY bin/docker-entrypoint /opt/bin/
COPY conf/*.xml conf/*.xsl /work/
COPY lib/fop-hyph.jar /opt/fop-2.10/fop/build/

## fonts for pdf gen
RUN if [ "$pdfgen" = "1" ]; then (apk add ttf-dejavu fontconfig \
    && mkdir -p /usr/share/fonts/noto/jp \
    && wget -q https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip -O /tmp/noto.zip \
    && unzip /tmp/noto.zip -d /usr/share/fonts/noto/jp && rm /tmp/noto.zip  \
    && mkdir -p /usr/share/fonts/noto/sc \
    && wget -q https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKsc-hinted.zip -O /tmp/noto.zip \
    && unzip /tmp/noto.zip -d /usr/share/fonts/noto/sc && rm /tmp/noto.zip  \
    && chmod -R o+r /usr/share/fonts/noto && fc-cache -f); fi

## Runtime configuration
USER omegat
WORKDIR /work/root/doc_src
ENV PATH $PATH:/opt/bin:/opt/apache-ant-1.10.14/bin
ENTRYPOINT ["docker-entrypoint", "ant"]
