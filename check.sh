#!/bin/bash

AUR_NAME=lms
GUTHUB_REPO=epoupon/lms

if [ ! -f aur.json ]; then
    curl -L \
        -o aur.json \
        "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=${AUR_NAME}" >/dev/null 2>&1
fi
version=$(cat aur.json | grep -E -o '"Version": *"[^"]+"' | grep -E -o "[0-9]+.[0-9]+.[0-9]+")
if [ -z "$version" ]; then
    echo "Can't get package version"
    exit 1
fi

echo "Package version: $version"


if [ ! -f github.json ]; then
    curl -L \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -o github.json \
        "https://api.github.com/repos/${GUTHUB_REPO}/releases/latest" >/dev/null 2>&1
fi
tag_name=$(cat github.json | grep -E -o '"tag_name": *"[^"]+"' | cut -d '"' -f4)
echo "Tag: $tag_name"

rm -f aur.json github.json

validated_release_version=$(echo "$tag_name" | grep -E -o "[0-9]+\.[0-9]+\.[0-9]+")
if [ "v$validated_release_version" != "$tag_name" ]; then
    echo "Tag validation failed"
    echo "::set-output name=skip::true"
    exit 0
fi

if [ "v$version" == "$tag_name" ]; then
    echo "::set-output name=skip::true"
else
    echo "::set-output name=skip::false"
    echo "::set-output name=version::$validated_release_version"
fi
