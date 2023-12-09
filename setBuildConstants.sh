#!/bin/bash


COMMIT_HASH=$(git rev-parse --short HEAD)
BUILD_DATE=$(date -u --iso-8601=minutes | sed s/+00:00/Z/)

echo "build hash: $COMMIT_HASH"
echo "build date: $BUILD_DATE"

sed -i "s/var commit_hash = \"dev\"/var commit_hash = \"$COMMIT_HASH\"/" singletons/build_info.gd
sed -i "s/var build_time = \"dev\"/var build_time = \"$BUILD_DATE\"/" singletons/build_info.gd

