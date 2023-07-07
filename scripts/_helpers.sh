#!/bin/bash

set -euf -o pipefail

contentBuild () {
    SOURCE_DIR="assets/images"
    TARGET_DIR="content/all"
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    TARGET_RELATIVE_DIR="${SCRIPT_DIR}/../${TARGET_DIR}"
    IMAGE_REGEX="^([0-9]+)-([a-z-]+)\.jpg$"

    rm -rf "${TARGET_RELATIVE_DIR}/*"

    for source_file in $(find "${SCRIPT_DIR}/../${SOURCE_DIR}" -name "*.jpg" ! -name "about.jpg")
    do
        image_type=$(basename ${source_file} | sed -r "s/${IMAGE_REGEX}/\2/g")
        image_weight=$(basename ${source_file} | sed -r "s/${IMAGE_REGEX}/\1/g")
        target_tag_dir="${TARGET_RELATIVE_DIR}/${image_type}"
        target_file="${target_tag_dir}/${image_weight}-${image_type}.md"
        image_path="${source_file#"${SCRIPT_DIR}/../assets"}"
        printf "Building %s\n" "${image_path}"
        mkdir -p "${target_tag_dir}"
        cat >"${target_file}" <<EOT
---
hideDate: true
hideExif: true
hideTitle: true
images:
- ${image_path}
tags:
- all
- ${image_type}
weight: ${image_weight}
---
EOT
    done
}

siteBuild () {
    PUBLIC_DIR="${SCRIPT_DIR}/../public"
    rm -rf "${PUBLIC_DIR}"
    mkdir -p "${PUBLIC_DIR}"
    hugo --minify
}

siteRun () {
    hugo server
}
