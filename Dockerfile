FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    docbook-xsl \
    docbook-xml \
    fop \
    libxml2-utils \
    libsaxon-java \
    ant \
    ttf-dejavu \
    fonts-ipafont \
    fonts-wqy-microhei \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://www.xmlmind.com/ditac/_whc/whc-3_1_1.zip -O /tmp/whc.zip \
    && unzip /tmp/whc.zip -d /opt \
    && rm /tmp/whc.zip

WORKDIR /work/root/doc_src

COPY *.xml *.xsl /work/

COPY docker-entrypoint /opt/bin/
ENV PATH $PATH:/opt/bin

RUN ln -s /usr/share/xml/docbook/schema/dtd/4.5/ /work/docbook-xml-4.5

USER nobody

ENTRYPOINT ["docker-entrypoint", "ant"]
