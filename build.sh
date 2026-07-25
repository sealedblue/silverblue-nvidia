#!/usr/bin/bash
set -euxo pipefail
. ./env.sh

if [[ "$TAG" != "$MAIN_BRANCH" ]] && ! [[ -e "diverge-$TAG" ]]; then
    podman pull  "$MAIN_IMAGE"
    podman tag "$MAIN_IMAGE" "${IMAGE}"
else
    podman pull  "$BASE_IMAGE"
    podman build \
        --security-opt=label=disable \
        --build-arg "BASE_IMAGE=$BASE_IMAGE" \
        -t "${IMAGE}" .
fi
./push.sh
