#!/bin/bash

network='live'

print_usage() {
	echo 'build.sh [-h] [-n {live|beta|test}]'
}

while getopts 'hn:' OPT; do
	case "${OPT}" in
		h)
			print_usage
			exit 0
			;;
		n)
			network="${OPTARG}"
			;;
		*)
			print_usage >&2
			exit 1
			;;
	esac
done

case "${network}" in
	live)
		network_tag=''
		;;
	test|beta)
		network_tag="-${network}"
		;;
	*)
		echo "Invalid network: ${network}" >&2
		exit 1
		;;
esac

REPO_ROOT=`git rev-parse --show-toplevel`
COMMIT_SHA=`git rev-parse --short HEAD`
pushd $REPO_ROOT
<<<<<<< HEAD
docker build -f docker/node/Dockerfile -t bolt-node:latest .
=======
docker build --build-arg NETWORK="${network}" -f docker/node/Dockerfile -t raiblocks-node${network_tag}:latest .
>>>>>>> 283957ee1b4fcb1099c31a1d8c5583c27027d2bf
popd
