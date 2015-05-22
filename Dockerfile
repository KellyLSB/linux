FROM debian-jessie-armhf
MAINTAINER Kelly Lauren-Summer Becker-Neuding <kbecker@kellybecker.me>

RUN apt-get install u-boot-tools

ENV DEB_HOST_ARCH armhf
ENV CONCURRENCY_LEVEL 2
ENV EXTRAVERSION -kbeckerneuding-20150521
ENV UIMAGE_LOADADDR=10008000

# @TODO: Consider moving the armhf-toolchain
ENV CC=/usr/bin/arm-linux-gnueabihf-gcc

WORKDIR /build

ADD /stable-src /build
ADD /novena-src/arch/arm/configs/novena_defconfig \
  /build/arch/arm/configs/novena_defconfig
ADD /novena-src/arch/arm/boot/dts/imx6q-novena.dts \
  /build/arch/arm/boot/dts/imx6q-novena.dts

RUN make novena_defconfig

RUN env

RUN make-kpkg --arch=$ARCH --initrd \
  --cross-compile=$CROSS_COMPILE \
  --append-to-version=$EXTRAVERSION \
  kernel_image kernel_headers

RUN make UIMAGE_LOADADDR=$UIMAGE_LOADADDR uImage
RUN make UIMAGE_LOADADDR=$UIMAGE_LOADADDR imx6q-novena.dtb

RUN mkdir /built

RUN cp arch/arm/boot/uImage /built/uImage
RUN cp arch/arm/boot/dts/imx6q-novena.dtb /built/imx6q-novena.dtb
RUN mv /*.deb /built/

WORKDIR /built

ENTRYPOINT tar -cf - *
