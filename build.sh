#!/usr/bin/bash
set -euxo pipefail
. ./env.sh

if [[ "$TAG" != "$MAIN_BRANCH" ]] && ! [[ -e "diverge-$TAG" ]]; then
    DIGEST_NAME=$(systemd-escape "$IMAGE")
    skopeo copy --sign-by-sigstore-private-key keys/sealedblue-staged.private \
        --sign-passphrase-file keys/sealedblue-staged.passphrase \
        --digestfile "${DIGEST_NAME}.digest" \
        "docker://${MAIN_IMAGE}" "docker://${IMAGE}"
else
    podman pull  "$BASE_IMAGE"
    podman build \
        --security-opt=label=disable \
        --build-arg "BASE_IMAGE=$BASE_IMAGE" \
        -t "${IMAGE}" .
    ./push.sh
fi
