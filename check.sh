#!/usr/bin/bash
set -euo pipefail
. ./env.sh

pkg-list() {
    podman run --rm "$1" rpm -q --qf="%{NAME}\n" -a
}

podman pull  "${BASE_IMAGE}"
DIFF=$(printf '%s\n%s\n' "$(pkg-list "$BASE_IMAGE")" "$(pkg-list "$IMAGE")" | sort | uniq -u)
set -x
podman run --rm "$IMAGE" dnf check-upgrade $DIFF

DIGEST1="$(podman image inspect --format '{{index .Annotations "org.opencontainers.image.base.digest"}}' "${IMAGE}")"
DIGEST2="$(skopeo inspect containers-storage:${BASE_IMAGE} --format '{{.Digest}}')"
[ "${DIGEST1}" = "${DIGEST2}" ]
