#!/bin/bash

set -euf -o pipefail

contentBuild () {
    SOURCE_DIR="assets/images"
    TARGET_DIR="content/all"
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    TARGET_RELATIVE_DIR="${SCRIPT_DIR}/../${TARGET_DIR}"

    rm -rf "${TARGET_RELATIVE_DIR}/*"

    for source_file in $(find "${SCRIPT_DIR}/../${SOURCE_DIR}" -mindepth 2 -name "*.jpg")
    do
        image_type=$(basename `dirname ${source_file}`)
        image_weight=$(basename ${source_file} | awk -F. '{print $1}')
        target_tag_dir="${TARGET_RELATIVE_DIR}/${image_type}"
        target_file="${target_tag_dir}/${image_weight}.md"
        image_path="${source_file#"${SCRIPT_DIR}/../assets"}"
        printf "Building %s\n" "${image_path}"
        mkdir -p "${target_tag_dir}"
        cat >"${target_file}" <<EOT
---
hideExif: true
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
