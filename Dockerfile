FROM ubuntu:22.04

# уменьшаем размер образа, отключая установку рекомендуемых и предлагаемых пакетов
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker \
    && echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# устанавливаем необходимые пакеты
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    ca-certificates \
    build-essential \
    # очищаем кэш, чтобы образ не раздувался
    && rm -rf /var/lib/apt/lists/*


