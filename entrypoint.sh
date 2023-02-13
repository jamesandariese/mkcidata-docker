#!/bin/sh

set -e

rm -rf /tmp/build-iso
mkdir -p /tmp/build-iso
cd /tmp/build-iso
mkdir -p /out

while [ $# -gt 0 ];do
    f="$1"
    filename="${f%%=*}"
    echo "Writing out $filename"
    contents="${f#*=}"
    echo -n "$contents" > /tmp/build-iso/"$filename"
    shift
done

ls /tmp/build-iso

mkisofs -J -R -V ${VOLUMEID:-CIDATA} -o /out/build-iso.iso /tmp/build-iso
