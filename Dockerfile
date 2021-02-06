FROM alpine:3.13 AS build

WORKDIR /build

RUN apk add --no-cache git build-base cmake libpng-dev zlib-dev \
  && git clone https://github.com/Samsung/rlottie.git \
  && mkdir rlottie/build \
  && cd rlottie/build \
  && cmake .. \
  && make -j2 \
  && make install \
  && cd ../..

COPY . /build
RUN make CONF=Release

FROM alpine:3.13

RUN apk add --no-cache zlib libpng
COPY --from=build /usr/lib/librlottie.so* /usr/lib/
COPY --from=build /build/dist/Release/GNU-Linux/lottieconverter /usr/local/bin/lottieconverter
