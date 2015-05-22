FROM debian-jessie-armhf
MAINTAINER Kelly Lauren-Summer Becker-Neuding <kbecker@kellybecker.me>

#RUN apt-get install u-boot-tools

ENV DEB_HOST_ARCH armhf
ENV CONCURRENCY_LEVEL 2
ENV EXTRAVERSION -kbeckerneuding-20150521
ENV UIMAGE_LOADADDR=10008000

ENV CC=/usr/bin/arm-linux-gnueabihf-gcc

WORKDIR /build

ADD /stable-src /build
ADD /meta-kosagi/recipes-kernel/linux/linux-novena/defconfig \
  /build/arch/arm/configs/novena_defconfig
ADD /meta-kosagi/recipes-kernel/linux/linux-novena/imx6q-novena.dts \
  /build/arch/arm/boot/dts/imx6q-novena.dts

RUN make novena_defconfig

RUN env

RUN make-kpkg --arch=$ARCH --initrd \
  --cross-compile=$CROSS_COMPILE \
  --append-to-version=$EXTRAVERSION \
  kernel_image kernel_headers

# @TODO: This likely will need moved
RUN apt-get install u-boot-tools

RUN make UIMAGE_LOADADDR=$UIMAGE_LOADADDR uImage
RUN make UIMAGE_LOADADDR=$UIMAGE_LOADADDR imx6q-novena.dtb

RUN mkdir /built

RUN cp arch/arm/boot/uImage /built/uImage
RUN cp arch/arm/boot/dts/imx6q-novena.dtb /built/imx6q-novena.dtb
RUN mv /*.deb /built/

WORKDIR /built

ENTRYPOINT tar -cf - *
