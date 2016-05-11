#!/bin/bash
set -e
RUBY_VERSION=$1
arr=(${RUBY_VERSION//-/ })
TAG=${arr[0]}
NAME='pyro2927/centos-rbenv'
echo "Building $TAG..."
docker build --build-arg RUBY_VERSION=$RUBY_VERSION --tag="$NAME" .
docker tag $NAME $NAME:$TAG
docker push $NAME:$TAG
