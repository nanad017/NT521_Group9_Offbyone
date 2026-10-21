FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG FLAG=DUCTF{local_oversight}

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates socat wget \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash ctf

# Keep the challenge's original glibc 2.27 runtime.
RUN mkdir -p /opt/glibc-2.27 \
    && wget -q -O /tmp/libc6.deb \
       http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/libc6_2.27-3ubuntu1_amd64.deb \
    && dpkg-deb -x /tmp/libc6.deb /opt/glibc-2.27 \
    && rm -f /tmp/libc6.deb

WORKDIR /opt/oversight

COPY oversight ./oversight
COPY libc-2.27.so ./libc-2.27.so
COPY exploit.py ./exploit.py
COPY entrypoint.sh /entrypoint.sh
COPY run-challenge.sh /run-challenge.sh

RUN printf '%s\n' "${FLAG}" > ./flag.txt \
    && ln -s libc-2.27.so ./libc.so.6 \
    && chmod 0555 ./oversight /entrypoint.sh /run-challenge.sh \
    && chmod 0444 ./libc-2.27.so ./exploit.py ./flag.txt \
    && chown -R ctf:ctf /opt/oversight /entrypoint.sh /run-challenge.sh

USER ctf
EXPOSE 31909
ENTRYPOINT ["/entrypoint.sh"]
