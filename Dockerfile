FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    docbook-xsl \
    docbook-xml \
    icc-profiles-free \
    libbatik-java \
    libfontbox2-java \
    libxml2-utils \
    libsaxon-java \
    ant \
    fonts-dejavu \
    fonts-ipafont \
    fonts-wqy-microhei \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://www.xmlmind.com/ditac/_whc/whc-3_5_1.zip -O /tmp/whc.zip \
    && unzip /tmp/whc.zip -d /opt \
    && rm /tmp/whc.zip
RUN wget https://dlcdn.apache.org/xmlgraphics/fop/binaries/fop-2.9-bin.zip -O /tmp/fop.zip \
    && unzip /tmp/fop.zip -d /opt \
    && rm /tmp/fop.zip

WORKDIR /work/root/doc_src

COPY conf/*.xml conf/*.xsl /work/
COPY lib/*.jar /opt/fop-2.9/fop/build/

COPY bin/docker-entrypoint /opt/bin/
ENV PATH $PATH:/opt/bin

RUN ln -s /usr/share/xml/docbook/schema/dtd/4.5/ /work/docbook-xml-4.5
RUN adduser --disabled-password --gecos "" --home /work/ --shell /bin/bash omegat && mkdir -p /work/.fop && chown omegat /work/.fop

USER omegat

ENTRYPOINT ["docker-entrypoint", "ant"]
