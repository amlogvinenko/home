FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VELOCITY_DIR=/srv/velocity
ENV GRAALVM_VERSION=21.0.2
ENV GRAALVM_HOME=/opt/graalvm
ENV JAVA_HOME=/opt/graalvm
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl jq bash tar sed \
    && curl -fsSL "https://github.com/graalvm/graalvm-ce-builds/releases/download/jdk-${GRAALVM_VERSION}/graalvm-community-jdk-${GRAALVM_VERSION}_linux-x64_bin.tar.gz" -o /tmp/graalvm.tar.gz \
    && GRAALVM_DIR="$(tar -tf /tmp/graalvm.tar.gz | head -1 | cut -d/ -f1)" \
    && tar -xzf /tmp/graalvm.tar.gz -C /opt \
    && mv "/opt/${GRAALVM_DIR}" "${GRAALVM_HOME}" \
    && ln -sf "${JAVA_HOME}/bin/java" /usr/local/bin/java \
    && rm -f /tmp/graalvm.tar.gz \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/bootstrap
COPY entrypoint.sh download-velocity.sh velocity.toml.template ./
RUN chmod +x /opt/bootstrap/entrypoint.sh /opt/bootstrap/download-velocity.sh

WORKDIR ${VELOCITY_DIR}
ENTRYPOINT ["/opt/bootstrap/entrypoint.sh"]
