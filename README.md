# Linux Kernel Builder

__This Dockerfile has dependencies on the `debian-jessie-armhf` container.
Which can be built using the tools here: https://github.com/KellyLSB/armhf-toolchain__

At the moment the Dockerfile in this repository is configured to handle running the build process for the Kernel and Device Tree Blobs for the Kosagi - Novena. In the future it will also include build configurations for other machines as well.

## Usage

At the moment there is no Makefile or other build script. You will need to prepare the repository by checking out the *gulp* submodules.

    $ git submodule update --init --checkout
    $ docker build -t linux-novena .
    $ docker run -it linux-novena | tar -xf -

In theory it should place `uImage` and `imx6q-novena.dtb` into the current path.

__This is neat because you can use it to grab your kernel whenever you want!__
