FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PAPER_DIR=/srv/paper
ENV GRAALVM_TARBALL_URL=https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.2.0/graalvm-ce-java16-linux-amd64-21.2.0.tar.gz
ENV GRAALVM_HOME=/opt/graalvm
ENV JAVA_HOME=/opt/graalvm
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl jq bash tar sed \
    && curl -fL --retry 6 --retry-all-errors --retry-delay 2 "${GRAALVM_TARBALL_URL}" -o /tmp/graalvm.tar.gz \
    && GRAALVM_DIR="$(tar -tf /tmp/graalvm.tar.gz | head -1 | cut -d/ -f1)" \
    && tar -xzf /tmp/graalvm.tar.gz -C /opt \
    && mv "/opt/${GRAALVM_DIR}" "${GRAALVM_HOME}" \
    && ln -sf "${JAVA_HOME}/bin/java" /usr/local/bin/java \
    && rm -f /tmp/graalvm.tar.gz \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/bootstrap
COPY entrypoint.sh download-paper.sh ./
RUN chmod +x /opt/bootstrap/entrypoint.sh /opt/bootstrap/download-paper.sh

WORKDIR ${PAPER_DIR}
ENTRYPOINT ["/opt/bootstrap/entrypoint.sh"]
