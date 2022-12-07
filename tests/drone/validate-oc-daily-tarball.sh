#! /bin/bash
set -e

if [[ -z "${DAILY_TARBALLS}" ]]; then
    echo "[ERROR] 'DAILY_TARBALLS' is not set"
    echo "[INFO] Provide 'DAILY_TARBALLS' as env with values separated by comma"
    exit 1
fi

DOWNLOAD_URL="https://download.owncloud.com/server/daily"
DESTINATION="/tmp/owncloud"
EXIT_CODE=1

IFS=',' read -ra TARBALLS <<<"$DAILY_TARBALLS"
for TARBALL in "${TARBALLS[@]}"; do
    # create the destination
    mkdir -p "${DESTINATION}"

    # remove white spaces
    TARBALL=$(echo "${TARBALL}" | tr -d '[:space:]')
    if [[ "${TARBALL}" != "owncloud-*" ]] && [[ "${TARBALL}" != "*.tar.bz2" ]]; then
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
        echo "[INFO] Today: ${BUILD_DATE}"
        EXIT_CODE=1
    fi
done

exit ${EXIT_CODE}
