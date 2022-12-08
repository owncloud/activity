#! /bin/bash
set -e

# Args:
# 1...n - tarballs to check

if ! [[ $# -gt 0 ]]; then
    echo "[ERROR] Tarball is not provided"
    echo "[INFO] Provide tarballs as command args separated by a space"
    exit 1
fi

DOWNLOAD_URL="https://download.owncloud.com/server/daily"
DESTINATION="/tmp/owncloud"
EXIT_CODE=1

while [[ $# -gt 0 ]]; do
    # create the destination
    mkdir -p "${DESTINATION}"

    # remove white spaces
    TARBALL=$(echo "$1" | tr -d '[:space:]')

    if ! [[ "${TARBALL}" =~ ^owncloud-.* ]] && ! [[ "${TARBALL}" =~ .*\.tar\.bz2$ ]]; then
        TARBALL="owncloud-${TARBALL}.tar.bz2"
    fi

    echo -e "\n-----------------------------------------------------------------"
    echo "[INFO] Checking tarball '${TARBALL}'"
    echo "[INFO] Downloading '${DOWNLOAD_URL}/${TARBALL}'"
    echo "[INFO] Extracting tarball to '${DESTINATION}'"
    # download and extract the tarball
    wget -qO- "${DOWNLOAD_URL}/${TARBALL}" | tar -xj -C "${DESTINATION}" --strip 1

    BUILD_DATE=$(grep "\$OC_Build =" "${DESTINATION}/version.php")
    BUILD_DATE=$(echo "${BUILD_DATE}" | grep -Eo "[0-9\-]+" | head -1)

    TODAY=$(date +%Y-%m-%d)
    # busybox date does not support the following format:
    #   -d "-1 days"
    YESTERDAY=$(date -d "@$(($(date +%s) - 86400))" +%Y-%m-%d)

    # cleanup the destination
    rm -rf "${DESTINATION}"

    if [[ "${BUILD_DATE}" == "${TODAY}" || "${BUILD_DATE}" == "${YESTERDAY}" ]]; then
        echo "[SUCCESS] Daily tarball '${TARBALL}' is up to date"
        EXIT_CODE=0
    else
        echo "[ERROR] Daily tarball '${TARBALL}' is not up to date"
        echo "[INFO] Tarball build date: ${BUILD_DATE}"
        echo "[INFO] Today: ${TODAY}"
        EXIT_CODE=1
    fi
    shift
done

exit ${EXIT_CODE}
