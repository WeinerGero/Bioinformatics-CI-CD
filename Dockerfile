FROM ubuntu:22.04

# уменьшаем размер образа, отключая установку рекомендуемых и предлагаемых пакетов
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker \
    && echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# устанавливаем базовые пакеты
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    ca-certificates \
    cmake \
    build-essential \
    # очищаем кэш, чтобы образ не раздувался
    && rm -rf /var/lib/apt/lists/*

ENV SOFT=/soft

# libdeflate 1.26, дата релиза 22.08.2026
RUN curl -L https://github.com/ebiggers/libdeflate/releases/download/v1.26/libdeflate-1.26.tar.gz \
    | tar -xz -C /tmp \
    && cmake -S /tmp/libdeflate-1.26 \
    -B /tmp/libdeflate-build \
    -DCMAKE_INSTALL_PREFIX="$SOFT/libdeflate-1.26" \
    && cmake --build /tmp/libdeflate-build --parallel "$(nproc)" \
    && cmake --install /tmp/libdeflate-build \
    # очищаем временные файлы сборки, чтобы образ не раздувался
    && rm -rf /tmp/libdeflate-1.26 /tmp/libdeflate-build

ENV PATH="$SOFT/libdeflate-1.26/bin:$PATH"
