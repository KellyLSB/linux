FROM debian-jessie-armhf
MAINTAINER Kelly Lauren-Summer Becker-Neuding <kbecker@kellybecker.me>

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

RUN make uImage
RUN make imx6q-novena.dtb

RUN cp arch/arm/boot/uImage uImage
RUN cp arch/arm/boot/dts/imx6q-novena.dtb imx6q-novena.dtb

ENTRYPOINT tar -cf - uImage imx6q-novena.dtb
