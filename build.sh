#!/usr/bin/bash
set -euxo pipefail
. ./env.sh

git remote set-head origin -a
MAIN_BRANCH="$(git symbolic-ref refs/remotes/origin/HEAD | cut -d/ -f4)"
if [[ "$TAG" != "$MAIN_BRANCH" ]] && ! [[ -e "diverge-$TAG" ]]; then
    podman tag "${IMAGE_PREFIX}/${IMAGE_NAME}:${MAIN_BRANCH}-unsealed" "${IMAGE}"
else
    podman pull  "$BASE_IMAGE"
    podman build \
        --security-opt=label=disable \
        --build-arg "BASE_IMAGE=$BASE_IMAGE" \
        -t "${IMAGE}" .
fi
./push.sh
