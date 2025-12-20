ARG FLAVOUR="${FLAVOUR:-}"

FROM scratch AS ctx
COPY build_files /build
COPY system_files /files

COPY --from=ghcr.io/ublue-os/akmods-nvidia-open:main-43-x86_64 / /tmp/akmods-nvidia

FROM ghcr.io/ublue-os/base-main:latest

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/00-build.sh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/01-nvidia.sh
    
RUN bootc container lint
