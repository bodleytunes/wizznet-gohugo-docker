
FROM ubuntu:20.04 

# available for build
ARG GO_VER
# available for running container
ENV GO_VER=${GO_VER}

RUN apt-get update && apt install wget git gcc g++ -y  && \
    wget https://golang.org/dl/go${GO_VER}.linux-amd64.tar.gz  && \
    tar  -C /usr/local -xzf "go$GO_VER.linux-amd64.tar.gz" && \
    mkdir -p /go && mkdir -p /go/src



ENV PATH=$PATH:/usr/local/go/bin:/go/bin
ENV GOPATH=/go

RUN cd /go/src && git clone https://github.com/gohugoio/hugo.git && cd hugo && go install --tags extended

COPY ./site /go/src/github.com/wizzblog

WORKDIR /go/src/github.com/wizzblog

ENTRYPOINT ["hugo", "server", "-D", "--bind", "0.0.0.0"]

