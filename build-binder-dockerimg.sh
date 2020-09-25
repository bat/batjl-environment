#!/bin/bash

set -ex

dockerorg="batk"

rm -f Dockerfile

hash=`(cd "${builddir}" && sha1sum *) | sha1sum | head -c 12`
datestr=`date -u +'%Y%m%d'`
# imgname="${dockerorg}/batjl-binder-base:${datestr}-${hash}"
imgname="${dockerorg}/batjl-binder-base:${hash}"

jupyter-repo2docker --no-run --image-name "${imgname}" .

echo "FROM $imgname" > Dockerfile
