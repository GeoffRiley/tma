FROM debian:stable-slim

# Basic tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    make git perl python3 \
    && rm -rf /var/lib/apt/lists/*

# TeX Live (full for CTAN-style testing)
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-full \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["/bin/bash"]
