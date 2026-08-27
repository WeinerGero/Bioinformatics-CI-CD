FROM ubuntu:22.04

# уменьшает размер образа, отключая установку рекомендуемых и предлагаемых пакетов
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker \
    && echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

# устанавливает базовые пакеты и зависимости для сборки приложений
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    curl \
    ca-certificates \
    cmake \
    build-essential \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
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
    && rm -rf /tmp/libdeflate-1.26 /tmp/libdeflate-build

# HTSlib 1.24, дата релиза 09.07.2026
RUN curl -L https://github.com/samtools/htslib/releases/download/1.24/htslib-1.24.tar.bz2 \
    | tar -xj -C /tmp \
    && cd /tmp/htslib-1.24 \
    && CPPFLAGS="-I$SOFT/libdeflate-1.26/include" \
    LDFLAGS="-L$SOFT/libdeflate-1.26/lib -Wl,-rpath,$SOFT/libdeflate-1.26/lib" \
    ./configure \
    --prefix="$SOFT/htslib-1.24" \
    --with-libdeflate \
    && make -j "$(nproc)" \
    && make install \
    && rm -rf /tmp/htslib-1.24

# Samtools 1.24, дата релиза 09.07.2026
RUN curl -L https://github.com/samtools/samtools/releases/download/1.24/samtools-1.24.tar.bz2 \
    | tar -xj -C /tmp \
    && cd /tmp/samtools-1.24 \
    && CPPFLAGS="-I$SOFT/htslib-1.24/include" \
    LDFLAGS="-L$SOFT/htslib-1.24/lib -Wl,-rpath,$SOFT/htslib-1.24/lib" \
    ./configure \
    --prefix="$SOFT/samtools-1.24" \
    --with-htslib="$SOFT/htslib-1.24" \
    && make -j "$(nproc)" \
    && make install \
    && rm -rf /tmp/samtools-1.24

ENV SAMTOOLS="$SOFT/samtools-1.24/bin/samtools"

ENV PATH="$SOFT/libdeflate-1.26/ \
    bin:$SOFT/htslib-1.24/ \
    bin:$SOFT/samtools-1.24/ \
    bin:$SOFT/bcftools-1.24/ \
    bin:$SOFT/vcftools-0.1.17/ \
    bin:$PATH"
