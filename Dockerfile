FROM alpine

ARG GMSSL_VERSION=3.1.0
ARG SHA=668552fe89bc34ab0ed616a11ea6f6dad5efe610d2653c342db7726eae5f457d797306e9c8ad703d15591ae912fbe5008ac4319545ac6e36b315c324ecc17d00
ARG BASE_URL=https://github.com/guanzhi/GmSSL/archive/refs/tags

RUN <<EOF
apk --no-cache add curl cmake make gcc g++ libc-dev linux-headers
EOF

RUN <<EOF
curl -fsSL -o GmSSL-${GMSSL_VERSION}.tar.gz ${BASE_URL}/v${GMSSL_VERSION}.tar.gz
echo "${SHA}  GmSSL-${GMSSL_VERSION}.tar.gz" | sha512sum -c -
tar -xzf GmSSL-${GMSSL_VERSION}.tar.gz --strip-components=1
mkdir build
cd build
cmake ..
make
make test
make install
EOF

FROM alpine
COPY --from=0 /usr/local/bin/gmssl /usr/local/bin
COPY --from=0 /usr/local/include/gmssl /usr/local/include
COPY --from=0 /usr/local/lib/libgmssl.* /usr/local/lib
WORKDIR /root
ENTRYPOINT ["gmssl"]
