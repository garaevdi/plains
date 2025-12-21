ARG BUILD_FLAVOUR="${BUILD_FLAVOUR:-}"

FROM scratch AS ctx
COPY build_files /build
COPY system_files /files

FROM ghcr.io/ublue-os/akmods-nvidia-open:main-43-x86_64 as akmods-nvidia
FROM ghcr.io/ublue-os/base-main:latest
ARG BUILD_FLAVOUR="${BUILD_FLAVOUR:-}"

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/00-build.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=bind,from=akmods-nvidia,src=/rpms,dst=/tmp/akmods-nvidia \
    --mount=type=cache,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/01-nvidia.sh
    
RUN bootc container lint
