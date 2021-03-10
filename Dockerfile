
FROM ubuntu:20.04 

# available for build
ARG GO_VER
# available for running container
ENV GO_VER=${GO_VER}

RUN apt-get update && apt install wget git gcc g++ -y  && \
    wget https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz  && \
    tar  -C /usr/local -xzf "go$GO_VER.linux-amd64.tar.gz" && \
    mkdir -p /go && mkdir -p /go/src && mkdir -p /go/src/github.com



ENV PATH=$PATH:/usr/local/go/bin:/go/bin
ENV GOPATH=/go

RUN cd /go/src && git clone https://github.com/gohugoio/hugo.git && cd hugo && go install --tags extended && \
    cd /go/src/github.com && hugo new site wizzblog && cd /go/src/github.com/wizzblog && git init && \
    git submodule add https://github.com/maxlefou/hugo.386.git themes/hugo.386 

COPY ./site/wizzblog /go/src/github.com/wizzblog

WORKDIR /go/src/github.com/wizzblog

ENTRYPOINT ["hugo", "server", "-D", "--bind", "0.0.0.0"]

