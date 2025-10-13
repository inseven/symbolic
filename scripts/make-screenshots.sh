#!/bin/bash

set -e

ROOT_DIRECTORY="$( cd "$( dirname "$( dirname "${BASH_SOURCE[0]}" )" )" &> /dev/null && pwd )"

function screenshot_light {
    convert \
        -size 2880x1800 \
        -define gradient:direction=northeast \
        gradient:"rgb(105 105 244)-rgb(105 105 244)" \
        "$1" \
        -gravity Center \
        -geometry +0+0 \
        -composite "$2"
}

function screenshot_dark {
    convert \
        -size 2880x1800 \
        -define gradient:direction=northeast \
        gradient:"rgb(105 105 244)-rgb(105 105 244)" \
        "$1" \
        -gravity Center \
        -geometry +0+0 \
        -composite "$2"
}

screenshot_light "$ROOT_DIRECTORY/docs/images/screenshot-default@2x.png" "$ROOT_DIRECTORY/marketing/screenshot-default@2x.png"
screenshot_dark "$ROOT_DIRECTORY/docs/images/screenshot-default-dark@2x.png" "$ROOT_DIRECTORY/marketing/screenshot-default-dark@2x.png"
