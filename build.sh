#!/bin/sh
set -euxo pipefail
. ./env.sh

podman build --pull=newer \
    --security-opt=label=disable \
    --build-arg "BASE_IMAGE=$BASE_IMAGE" \
    -t "${IMAGE}" .
./push.sh
