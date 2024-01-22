FROM adoptopenjdk/openjdk11:alpine-jre

RUN apk add wget docbook-xml

RUN mkdir -p /opt/saxon/lib \
    && adduser --disabled-password --gecos "" --home /work/ --shell /bin/bash omegat && mkdir -p /work/root/doc_src \
    && mkdir -p /work/.fop && chown omegat /work/.fop \
    && wget https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-1.79.2.zip -O /tmp/docbook-xsl.zip \
    && unzip /tmp/docbook-xsl.zip -d /opt && rm /tmp/docbook-xsl.zip \
    && wget https://www.xmlmind.com/ditac/_whc/whc-3_5_1.zip -O /tmp/whc.zip \
    && unzip /tmp/whc.zip -d /opt && rm /tmp/whc.zip && rm -rf /opt/whc-3_5_1/doc /opt/whc-3_5_1/src /opt/whc-3_5_1/docsrc \
    && wget https://downloads.apache.org/ant/binaries/apache-ant-1.10.14-bin.zip -O /tmp/ant.zip \
    && unzip /tmp/ant.zip -d /opt && rm /tmp/ant.zip && rm -rf /opt/apache-ant-1.10.14/manual \
    && wget https://dlcdn.apache.org/xmlgraphics/fop/binaries/fop-2.9-bin.zip -O /tmp/fop.zip \
    && unzip /tmp/fop.zip -d /opt && rm /tmp/fop.zip && rm -rf /opt/fop-2.9/javadocs \
    && ln -s /usr/share/xml/docbook/xml-dtd-4.1.2/ /work/docbook-xml-4.5

COPY lib/saxon*.jar /opt/saxon/lib/
COPY bin/docker-entrypoint /opt/bin/
COPY conf/*.xml conf/*.xsl /work/
COPY lib/fop-hyph.jar /opt/fop-2.9/fop/build/

## fonts for pdf gen
#RUN apk add font-noto font-noto-cjk

## Runtime configuration
USER omegat
WORKDIR /work/root/doc_src
ENV PATH $PATH:/opt/bin:/opt/apache-ant-1.10.14/bin
ENTRYPOINT ["docker-entrypoint", "ant"]
