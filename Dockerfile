
FROM golang:latest

RUN apt-get update -y  && \
    mkdir -p /go && mkdir -p /go/src && mkdir -p /go/src/github.com && rm -rf /var/lib/apt/lists/*


ENV PATH=$PATH:/usr/local/go/bin:/go/bin
ENV GOPATH=/go


# Download and install hugo
ENV HUGO_VERSION 0.81.0
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.deb

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb

RUN cd /go/src && hugo new site wizzblog && cd /go/src/wizzblog && git init && \
    git submodule add https://github.com/maxlefou/hugo.386.git themes/hugo.386 

COPY ./site/wizzblog /go/src/wizzblog

WORKDIR /go/src/wizzblog

ENTRYPOINT ["hugo", "server", "-D", "--bind", "0.0.0.0"]

