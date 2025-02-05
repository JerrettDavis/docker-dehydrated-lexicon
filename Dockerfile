FROM python:alpine

LABEL maintainer="gabriel@melillo.me"

# Variables needed on setup
ARG DEHYDRATED_VERSION="0.7.0"

# Setup the environment
RUN apk add --update --no-cache gcc build-base python3-dev libffi-dev libressl-dev curl openssl openssl-dev musl-dev rust cargo bash && \
    curl -L https://github.com/dehydrated-io/dehydrated/archive/v${DEHYDRATED_VERSION}.tar.gz | tar -xz -C / && \
    mv /dehydrated-${DEHYDRATED_VERSION} /dehydrated && \
    mkdir -p /dehydrated/hooks /dehydrated/certs /dehydrated/accounts && \
    pip install --no-cache-dir dns-lexicon && \
    rm -rf /var/cache/apk/* ~/.cache /root/.cargo && \
    apk del --no-cache gcc build-base python3-dev libffi-dev libressl-dev openssl-dev musl-dev rust cargo

# Add necessary script to the image.
COPY entrypoint.sh /entrypont.sh
COPY dehydrated.default.sh /dehydrated/hooks/dehydrated.default.sh
COPY flattenCerts.py /dehydrated/flattenCerts.py

# Ensure the required permissions on the executables.
RUN chmod +x /dehydrated/hooks/dehydrated.default.sh && \
    chmod +x /entrypont.sh && \
    chmod +x /dehydrated/dehydrated && \
    chmod +w /dehydrated

# Provider to be used on lexicon.
# See a list of allowed provider on the project page.
ENV 'PROVIDER' 'unset'
# Default handler used by the docker compose.
# it is possible to overwire it mounting a new one and seting the new path on this variable.
ENV 'DEHYDRATED_HANDLER' '/dehydrated/hooks/dehydrated.default.sh'

WORKDIR /dehydrated

# Volume used by the script
VOLUME '/dehydrated/certs'
VOLUME '/dehydrated/accounts'
VOLUME '/dehydrated/chains'
VOLUME '/dehydrated/domains.txt'

ENTRYPOINT ["/entrypont.sh"]
