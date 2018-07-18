<<<<<<< HEAD
#!/usr/bin/env bash

build_dir=${1-${PWD}}

BUSYBOX_BASH=${BUSYBOX_BASH-0}

if [[ ${FLAVOR-_} == "_" ]]; then
    FLAVOR=""
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    TIMEOUT_CMD=gtimeout
else
    TIMEOUT_CMD=timeout
fi

set -o nounset
set -o xtrace


# Alpine doesn't offer an xvfb
xvfb_run_() {
    INIT_DELAY_SEC=3
    
    Xvfb :2 -screen 0 1024x768x24 &
    xvfb_pid=$!
    sleep ${INIT_DELAY_SEC}
    DISPLAY=:2 ${TIMEOUT_CMD} ${TIMEOUT_TIME_ARG} ${TIMEOUT_SEC-420} $@
    res=${?}
    kill ${xvfb_pid}
    
    return ${res}
}

run_tests() {
    # when busybox pretends to be bash it needs different args
    #   for the timeout builtin
    if [[ "${BUSYBOX_BASH}" -eq 1 ]]; then
        TIMEOUT_TIME_ARG="-t"
    else
        TIMEOUT_TIME_ARG=""
    fi
    
    ${TIMEOUT_CMD} ${TIMEOUT_TIME_ARG} ${TIMEOUT_SEC-420} ./core_test
    core_test_res=${?}
    
    xvfb_run_ ./qt_test
    qt_test_res=${?}
    
    ${TIMEOUT_CMD} ${TIMEOUT_TIME_ARG} ${TIMEOUT_SEC-420} ./load_test ./bolt_node
    load_test_res=${?}
    
    echo "Core Test return code: ${core_test_res}"
    echo "QT Test return code: ${qt_test_res}"
    echo "Load Test return code: ${load_test_res}"
    return $((${core_test_res} + ${qt_test_res} + ${load_test_res}))
}

cd ${build_dir}
run_tests
if [[ "$OSTYPE" == "darwin"* ]]; then
    TIMEOUT_CMD=gtimeout
else
    TIMEOUT_CMD=timeout
fi

set -o nounset
set -o xtrace


# Alpine doesn't offer an xvfb
xvfb_run_() {
    INIT_DELAY_SEC=3
    
    Xvfb :2 -screen 0 1024x768x24 &
    xvfb_pid=$!
    sleep ${INIT_DELAY_SEC}
    DISPLAY=:2 ${TIMEOUT_CMD} ${TIMEOUT_TIME_ARG} ${TIMEOUT_SEC-420} $@
    res=${?}
    kill ${xvfb_pid}
    
    return ${res}
}

run_tests() {
    # when busybox pretends to be bash it needs different args
    #   for the timeout builtin
    if [[ "${BUSYBOX_BASH}" -eq 1 ]]; then
        TIMEOUT_TIME_ARG="-t"
    else
        TIMEOUT_TIME_ARG=""
    fi
    
    ${TIMEOUT_CMD} ${TIMEOUT_TIME_ARG} ${TIMEOUT_SEC-420} ./core_test
    core_test_res=${?}
    
    xvfb_run_ ./qt_test
    qt_test_res=${?}
    
    ${TIMEOUT_CMD} ${TIMEOUT_TIME_ARG} ${TIMEOUT_SEC-420} ./load_test ./bolt_node
    load_test_res=${?}
    
    echo "Core Test return code: ${core_test_res}"
    echo "QT Test return code: ${qt_test_res}"
    echo "Load Test return code: ${load_test_res}"
    return $((${core_test_res} + ${qt_test_res} + ${load_test_res}))
}

cd ${build_dir}
run_tests
=======
#!/bin/bash

PATH="${PATH:-/bin}:/usr/bin"
export PATH

set -euo pipefail
IFS=$'\n\t'

network="$(cat /etc/nano-network)"
case "${network}" in
        live|'')
                network='live'
                dirSuffix=''
                ;;
        beta)
                dirSuffix='Beta'
                ;;
        test)
                dirSuffix='Test'
                ;;
esac

nanodir="${HOME}/RaiBlocks${dirSuffix}"
dbFile="${nanodir}/data.ldb"
mkdir -p "${nanodir}"
if [ ! -f "${nanodir}/config.json" ]; then
        echo "Config File not found, adding default."
        cp "/usr/share/raiblocks/config/${network}.json" "${nanodir}/config.json"
fi

pid=''
firstTimeComplete=''
while true; do
	if [ -n "${firstTimeComplete}" ]; then
		sleep 10
	fi
	firstTimeComplete='true'

	if [ -f "${dbFile}" ]; then
		dbFileSize="$(stat -c %s "${dbFile}" 2>/dev/null)"
		if [ "${dbFileSize}" -gt $[1024 * 1024 * 1024 * 20] ]; then
			echo "ERROR: Database size grew above 20GB (size = ${dbFileSize})" >&2

			while [ -n "${pid}" ]; do
				kill "${pid}" >/dev/null 2>/dev/null || :
				if ! kill -0 "${pid}" >/dev/null 2>/dev/null; then
					pid=''
				fi
			done

			rai_node --vacuum
		fi
	fi

	if [ -n "${pid}" ]; then
		if ! kill -0 "${pid}" >/dev/null 2>/dev/null; then
			pid=''
		fi
	fi

	if [ -z "${pid}" ]; then
		rai_node --daemon &
		pid="$!"
	fi
done
>>>>>>> 283957ee1b4fcb1099c31a1d8c5583c27027d2bf
