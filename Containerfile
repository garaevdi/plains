ARG FLAVOUR="${FLAVOUR:-}"
# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /build
COPY system_files /system

# Nvidia akmods
FROM ghcr.io/ublue-os/akmods-nvidia-open:main-43-x86_64 as akmods-nvidia
# Base Image
FROM ghcr.io/ublue-os/base-main:43
ARG FLAVOUR="${FLAVOUR:-}"

### MODIFICATIONS
# make modifications desired in your image and install packages by modifying the "00-build.sh" script
# the following RUN directive does all the things required to run "00-build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/00-build.sh

    RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=bind,from=akmods-nvidia,src=/rpms,dst=/tmp/akmods-nvidia \
    --mount=type=cache,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/01-nvidia.sh

### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
