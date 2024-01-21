FROM adoptopenjdk/openjdk11:alpine-jre

RUN apk add wget docbook-xsl docbook-xml

RUN wget https://www.xmlmind.com/ditac/_whc/whc-3_5_1.zip -O /tmp/whc.zip \
    && unzip /tmp/whc.zip -d /opt && rm /tmp/whc.zip && rm -rf /opt/whc-3_5_1/doc /opt/whc-3_5_1/src /opt/whc-3_5_1/docsrc \
    && wget https://dlcdn.apache.org/xmlgraphics/fop/binaries/fop-2.9-bin.zip -O /tmp/fop.zip \
    && unzip /tmp/fop.zip -d /opt && rm /tmp/fop.zip && rm -rf /opt/fop-2.9/javadocs \
    && wget https://downloads.apache.org/ant/binaries/apache-ant-1.10.14-bin.zip -O /tmp/ant.zip \
    && unzip /tmp/ant.zip -d /opt && rm /tmp/ant.zip && rm -rf /opt/apache-ant-1.10.14/manual \
    && mkdir -p /opt/saxon/lib

WORKDIR /work/root/doc_src

COPY conf/*.xml conf/*.xsl /work/
COPY lib/fop-hyph.jar /opt/fop-2.9/fop/build/
COPY lib/saxon*.jar /opt/saxon/lib/

COPY bin/docker-entrypoint /opt/bin/
ENV PATH $PATH:/opt/bin:/opt/apache-ant-1.10.14/bin

RUN ln -s /usr/share/xml/docbook/schema/dtd/4.5/ /work/docbook-xml-4.5
RUN adduser --disabled-password --gecos "" --home /work/ --shell /bin/bash omegat && mkdir -p /work/.fop && chown omegat /work/.fop

USER omegat

ENTRYPOINT ["docker-entrypoint", "ant"]
