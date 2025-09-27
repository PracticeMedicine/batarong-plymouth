#!/bin/bash

set -o pipefail
shopt -s failglob
set -u

log () {
	echo "install.sh[$$]: $*" >&2 || :
}

log_e () {
	echo -e "install.sh[$$]: $*" >&2 || :
}

SCRIPT_ROOT="$(cd "$(dirname "$0")" && echo $PWD)"
if [ -z "${SCRIPT_ROOT}" ]; then
	log "Couldn't find the root directory of the install.sh script! Aborting..."
	exit 1
fi

if (( EUID != 0 )); then
	log "The script needs to be ran as root (administrator). Relaunching..."
	pkexec "${SCRIPT_ROOT}/install.sh"
	exit 0
fi

BATARONG_DIR="${SCRIPT_ROOT}/batarong"
THEMES_DIR="/usr/share/plymouth/themes"

if [ ! -d "${BATARONG_DIR}" ]; then
	log "The \"${BATARONG_DIR}\" directory doesn't exist! Aborting..."
	exit 1
fi

if [ ! -d "${THEMES_DIR}" ]; then
	log "The \"${THEMES_DIR}\" directory doesn't exist! Aborting...
	exit 1
fi

log "Copying ${BATARONG_DIR} into ${THEMES_DIR}..."
cp -R "${BATARONG_DIR}" "${THEMES_DIR}"

log "Setting the default theme to \"batarong\"..."
plymouth-set-default-theme -R batarong

