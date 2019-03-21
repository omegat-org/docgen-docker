FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    docbook-xsl \
    docbook-xml \
    fop \
    libxml2-utils \
    libsaxon-java \
    ant \
    ttf-dejavu \
    fonts-noto-cjk \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

RUN curl -L 'http://www.apache.org/dyn/closer.cgi?filename=/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz&action=download' | tar xz

WORKDIR /work/root/doc_src

COPY *.xml *.xsl /work/

RUN ln -s /usr/share/xml/docbook/schema/dtd/4.5/ /work/docbook-xml-4.5

ENTRYPOINT ["ant"]
