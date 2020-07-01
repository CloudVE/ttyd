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
        unzip \
        curl; \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh --no-check-certificate && \
    bash ./miniconda.sh -b -p /usr/bin/miniconda && \
    rm ./miniconda.sh && \
    /usr/bin/miniconda/bin/conda init bash && \
    wget https://github.com/uc-cdis/cdis-data-client/releases/download/2020.07/dataclient_linux.zip -O gen3client.zip --no-check-certificate && \
    unzip gen3client.zip && mv gen3-client /usr/local/bin && \
    pip install bioblend

EXPOSE 7681

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["ttyd", "bash"]
