FROM ubuntu:latest

# Install dependencies required for building BusyBox
RUN apt-get update && apt-get install -y \
    wget \
    make \
    gcc \
    bzip2 \
    xz-utils \
    gcc-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    libncurses-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the build script into the image and make it executable
COPY build_busybox.sh /build_busybox.sh
RUN chmod +x /build_busybox.sh
COPY list_busybox_applets.sh /list_busybox_applets.sh
RUN chmod +x /list_busybox_applets.sh

# Set the script as the entry point, default version is provided here
ENTRYPOINT ["/build_busybox.sh"]