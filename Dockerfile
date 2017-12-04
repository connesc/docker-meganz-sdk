FROM debian:9 as builder

RUN apt-get update && apt-get install -y \
		autoconf \
		curl \
		g++ \
		libc-ares-dev \
		libcrypto++-dev \
		libcurl4-openssl-dev \
		libfreeimage-dev \
		libfuse-dev \
		libreadline-dev \
		libsodium-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libuv1-dev \
		make \
		zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

ARG SDK_VERSION=3.2.7

RUN curl -L https://github.com/meganz/sdk/archive/v${SDK_VERSION}.tar.gz | tar xz \
	&& mv sdk-${SDK_VERSION} sdk

WORKDIR sdk

RUN ./autogen.sh
RUN ./configure --with-libuv --prefix /usr
RUN make
RUN make install DESTDIR=/usr/src/output

FROM debian:9

RUN apt-get update && apt-get install -y \
		libc-ares2 \
		libcrypto++6 \
		libcurl3 \
		libfreeimage3 \
		libfuse2 \
		libreadline7 \
		libsodium18 \
		libsqlite3-0 \
		libssl1.1 \
		libuv1 \
		zlib1g \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/output /
