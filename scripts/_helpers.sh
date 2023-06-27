#!/bin/bash

set -euf -o pipefail

contentBuild () {
    SOURCE_DIR="assets/images/all"
    TARGET_DIR="content/all"
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    TARGET_RELATIVE_DIR="${SCRIPT_DIR}/../${TARGET_DIR}"

    rm -rf "${TARGET_RELATIVE_DIR}/*"

    for source_file in $(ls "${SCRIPT_DIR}/../${SOURCE_DIR}")
    do
        if [[ "$(echo ${source_file})" =~ [0-9]+-[a-z]+\.jpg ]]
        then
            source_tag=$(echo ${source_file} | awk -F- '{print $2}' | awk -F. '{print $1}')
            source_weight=$(echo ${source_file} | awk -F- '{print $1}')
            target_tag_dir="${TARGET_RELATIVE_DIR}/${source_tag}"
            target_file="${target_tag_dir}/${source_weight}-${source_tag}.md"
            image_path=$(echo "${SOURCE_DIR}/${source_file}" | sed 's/assets//g')
            printf "Building %s\n" "${source_file}"
            mkdir -p "${target_tag_dir}"
            cat >"${target_file}" <<EOT
---
hideExif: true
images:
- ${image_path}
tags:
- all
- ${source_tag}
weight: ${source_weight}
---
EOT
        fi
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
