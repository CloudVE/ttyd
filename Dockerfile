FROM tsl0922/musl-cross
RUN git clone --depth=1 https://github.com/CloudVE/ttyd.git /ttyd \
    && cd /ttyd && ./scripts/cross-build.sh x86_64

FROM ubuntu:18.04
COPY --from=0 /ttyd/build/ttyd /usr/bin/ttyd

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini; \
    apt-get -qq update && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        vim \
        git \
        wget \
        curl; \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh --no-check-certificate && \
    bash ./miniconda.sh -b -p /usr/bin/miniconda && \
    rm ./miniconda.sh && \
    /usr/bin/miniconda/bin/conda init bash

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "bash"]
